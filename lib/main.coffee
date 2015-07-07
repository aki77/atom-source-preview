{CompositeDisposable} = require 'atom'
PreviewView = require './preview-view'

module.exports =
  view: null
  subscriptions: null

  activate: (state) ->
    @views = new WeakMap
    @subscriptions = new CompositeDisposable
    @subscriptions.add(atom.commands.add('atom-text-editor[data-grammar~="coffee"]',
      'coffee-preview:toggle': ({target}) => @toggle(target?.getModel?())
    ))

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = null
    @view?.destroy()
    @view = null

  toggle: (editor) ->
    return unless editor

    if @view?.isAlive()
      @view.destroy()
      @view = null
    else
      @view = new PreviewView(editor)
      @view.show()
