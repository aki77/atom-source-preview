coffee = null

module.exports =
class CoffeeProvider
  fromScopeName: 'source.coffee'
  toScopeName: 'source.js'

  transform: (code, {sourceMap} = {}) ->
    coffee ?= require 'coffee-script'
    options =
      sourceMap: sourceMap ? false
    result = coffee.compile(code, options)

    unless options.sourceMap
      result = {js: result}

    {
      code: result.js
      sourceMap: result.v3SourceMap ? null
    }
