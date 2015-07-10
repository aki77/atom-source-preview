{CompositeDisposable} = require 'atom'
PreviewView = require './preview-view'
ProviderManager = require './provider-manager'

module.exports =
  view: null
  subscriptions: null

  config:
    enableBuiltinProvider:
      order: 1
      type: 'boolean'
      default: true
    enableSyncScroll:
      order: 2
      type: 'boolean'
      default: true
    RefreshDebouncePeriod:
      order: 3
      type: 'integer'
      default: 200


  activate: (state) ->
    @views = new WeakMap
    @subscriptions = new CompositeDisposable
    @subscriptions.add(atom.commands.add('atom-text-editor[data-grammar~="source"]',
      'source-preview:toggle': ({target}) => @toggle(target?.getModel?())
    ))

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = null
    @view?.destroy()
    @view = null
    @providerManager = null

  toggle: (editor) ->
    return unless editor

    if @view?.isAlive()
      @view.destroy()
      @view = null
    else
      {scopeName} = editor.getGrammar()
      provider = @getProviderManager().providerForScopeName(scopeName)
      return unless provider
      @view = new PreviewView(editor, provider)
      @view.show()

  getProviderManager: ->
    unless @providerManager?
      @providerManager = new ProviderManager
      @subscriptions.add(@providerManager)
    @providerManager

  consumeProvider: (providers) ->
    providers = [providers] if providers? and not Array.isArray(providers)
    return unless providers?.length > 0

    registrations = new CompositeDisposable
    providerManager = @getProviderManager()
    for provider in providers
      registrations.add(providerManager.registerProvider(provider))

    registrations
