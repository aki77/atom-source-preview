coffee = null

module.exports =
class CoffeeProvider
  fromScopeName: 'source.coffee'
  toScopeName: 'source.js'

  transform: (code, {sourceMap} = {}) ->
    coffee ?= require 'coffee-script'
    options =
      sourceMap: sourceMap ? false
      bare: atom.config.get('source-preview.coffeeProviderOptionBare')

    result = coffee.compile(code, options)
    result = {js: result} unless options.sourceMap

    {
      code: result.js
      sourceMap: result.v3SourceMap ? null
    }
