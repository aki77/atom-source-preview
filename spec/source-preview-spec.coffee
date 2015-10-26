path = require 'path'
coffee = require 'coffee-script'
_ = require 'underscore'

describe "CoffeePreview", ->
  [editor, editorElement, activationPromise, sourcePreview] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)
    spyOn(_._, 'now').andCallFake -> window.now

    atom.config.set('source-preview.enableSyncScroll', true)
    atom.config.set('source-preview.enableBuiltinProvider', true)
    atom.config.set('source-preview.coffeeProviderOptionBare', false)
    atom.config.set('source-preview.RefreshDebouncePeriod', 200)

    activationPromise = atom.packages.activatePackage('source-preview').then((pack) ->
      sourcePreview = pack.mainModule
    )

    waitsForPromise ->
      Promise.all([
        atom.packages.activatePackage('language-coffee-script')
        atom.packages.activatePackage('language-javascript')
      ])

    waitsForPromise ->
      url = path.join(__dirname, 'fixtures', 'sample.coffee')
      atom.workspace.open(url).then((_editor) ->
        editor = _editor
        editorElement = atom.views.getView(editor)
      )

  describe "when the atom-source-preview:toggle event is triggered", ->
    it "hides and shows the preview view", ->
      expect(atom.workspace.getTextEditors()).toHaveLength(1)
      atom.commands.dispatch editorElement, 'source-preview:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspace.getTextEditors()).toHaveLength(2)
        expect(sourcePreview.view.isAlive()).toBeTruthy()

        atom.commands.dispatch editorElement, 'source-preview:toggle'
        expect(atom.workspace.getTextEditors()).toHaveLength(1)
        expect(sourcePreview.view).toBeNull()

    it "compile", ->
      atom.commands.dispatch editorElement, 'source-preview:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        {previewEditor} = sourcePreview.view
        expect(previewEditor.getText()).toEqual(coffee.compile(editor.getText()))

    it "syncScroll", ->
      atom.commands.dispatch editorElement, 'source-preview:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        {previewEditor} = sourcePreview.view
        editor.setCursorBufferPosition([1, 2])
        advanceClock(200)
        expect(previewEditor.getSelectedBufferRange()).toEqual([[4, 0], [5, 0]])
        editor.setCursorBufferPosition([3, 0])
        advanceClock(200)
        expect(previewEditor.getSelectedBufferRange()).toEqual([[7, 0], [8, 0]])
