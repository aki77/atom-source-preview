coffee = require 'coffee-script'
_ = require 'underscore'
{CompositeDisposable, TextEditor} = require 'atom'

module.exports =
class PreviewView
  alive: true

  constructor: (@editor) ->
    @previewEditor = new TextEditor
    @previewEditor.setGrammar(atom.grammars.grammarForScopeName('source.js'))
    @previewEditor.getTitle = -> 'Coffee Preview'

    atom.config.observe('coffee-preview.refreshDebouncePeriod', (wait) =>
      @debouncedRenderPreview = _.debounce(@renderPreview, wait)
    )
    @debouncedSyncScroll = _.debounce(@syncScroll, 100)

    @handleEvents()
    @renderPreview()
    @syncScroll()

  destroy: =>
    return unless @isAlive()
    @alive = false
    @pane?.destroyItem(@previewEditor)
    @pane?.destroy()
    @pane = null
    @previewEditor?.destroy()
    @previewEditor = null
    @sourceMap = null
    @subscriptions?.dispose()
    @subscriptions = null

  isAlive: ->
    @alive

  handleEvents: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add(@editor.onDidStopChanging(@changeHandler))
    @subscriptions.add(@editor.onDidChangeCursorPosition(@changePositionHandler))
    @subscriptions.add(@editor.onDidDestroy(@destroy))
    @subscriptions.add(@previewEditor.onDidDestroy(@destroy))
    @subscriptions.add(atom.workspace.onDidChangeActivePaneItem(@changeItemHandler))

  changeHandler: =>
    @debouncedRenderPreview()

  changePositionHandler: ({oldBufferPosition, newBufferPosition}) =>
    unless oldBufferPosition.row is newBufferPosition.row
      @debouncedSyncScroll()

  changeItemHandler: (item) =>
    @destroy() unless item in [@editor, @previewEditor]

  syncScroll: =>
    bufferRow = @editor.getCursorBufferPosition().row
    for line in @sourceMap.lines.slice().reverse()
      continue unless line?
      for column in line.columns.slice().reverse()
        continue unless column?
        if column.sourceLine is bufferRow
          @previewEditor.setCursorBufferPosition([column.line, 0])
          @previewEditor.clearSelections()
          @previewEditor.selectLinesContainingCursors()
          @recenterTopBottom(@previewEditor)
          return

  renderPreview: =>
    @errorNotification?.dismiss()
    @errorNotification = null

    try
      {js, @sourceMap} = coffee.compile(@editor.getText(), sourceMap: true)
      @previewEditor.setText(js)
      @debouncedSyncScroll()
    catch error
      @errorNotification = atom.notifications.addError('CoffeeScript compile error', {
        dismissable: true
        detail: error.toString()
      })

  show: ->
    editorPane = atom.workspace.getActivePane()
    @pane = editorPane.splitRight(items: [@previewEditor])
    # restore focus
    editorPane.activate()

    editorElement = atom.views.getView(@previewEditor)
    atom.commands.add(editorElement, 'coffee-preview:toggle', @destroy)

  recenterTopBottom: (editor) ->
    editorElement = atom.views.getView(editor)
    minRow = Math.min((c.getBufferRow() for c in editor.getCursors())...)
    maxRow = Math.max((c.getBufferRow() for c in editor.getCursors())...)
    minOffset = editorElement.pixelPositionForBufferPosition([minRow, 0])
    maxOffset = editorElement.pixelPositionForBufferPosition([maxRow, 0])
    editor.setScrollTop((minOffset.top + maxOffset.top - editor.getHeight())/2)
