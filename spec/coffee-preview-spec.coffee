path = require 'path'
coffee = require 'coffee-script'
_ = require 'underscore'

describe "CoffeePreview", ->
  [editor, editorElement, activationPromise, coffeePreview] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)
    spyOn(_._, 'now').andCallFake -> window.now

    activationPromise = atom.packages.activatePackage('coffee-preview').then((pack) ->
      coffeePreview = pack.mainModule
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

  describe "when the atom-coffee-preview:toggle event is triggered", ->
    it "hides and shows the preview view", ->
      expect(atom.workspace.getTextEditors()).toHaveLength(1)
      atom.commands.dispatch editorElement, 'coffee-preview:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspace.getTextEditors()).toHaveLength(2)
        expect(coffeePreview.view.isAlive()).toBeTruthy()

        atom.commands.dispatch editorElement, 'coffee-preview:toggle'
        expect(atom.workspace.getTextEditors()).toHaveLength(1)
        expect(coffeePreview.view).toBeNull()

    it "compile", ->
      atom.commands.dispatch editorElement, 'coffee-preview:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        {previewEditor} = coffeePreview.view
        expect(previewEditor.getText()).toEqual(coffee.compile(editor.getText()))

    it "syncScroll", ->
      atom.commands.dispatch editorElement, 'coffee-preview:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        {previewEditor} = coffeePreview.view
        editor.setCursorBufferPosition([1, 0])
        advanceClock(100)
        expect(previewEditor.getSelectedBufferRange()).toEqual([[4, 0], [5, 0]])
        editor.setCursorBufferPosition([3, 0])
        advanceClock(100)
        expect(previewEditor.getSelectedBufferRange()).toEqual([[7, 0], [8, 0]])
