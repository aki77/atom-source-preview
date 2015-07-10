coffee = null

module.exports =
class CoffeeProvider
  fromScopeName: 'source.coffee'
  toScopeName: 'source.js'

  transform: (code) ->
    coffee ?= require 'coffee-script'
    {js, v3SourceMap} = coffee.compile(code, sourceMap: true)
    {
      code: js
      sourceMap: v3SourceMap
    }
