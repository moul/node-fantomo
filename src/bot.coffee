debug = require('debug') 'fantomo:lib:bot'
{Browser} = require './browser'
{EventEmitter} = require 'events'
{cache_url} = require './utils'


class module.exports.Bot extends Browser
  constructor: (@options = {}) ->
    debug 'init'
    @options.cache_dir ?= '/tmp'
    do @init if @init?
    super

  cache_url: (url, fn) ->
    opts =
      url: url
      dir: @options.cache_dir
    cache_url opts, fn

  inject: (code, args...) ->
    switch typeof code
      when 'function'
        debug "Injecting inline function"
        @evaluate code, args...
      when 'string'
        browserify = require 'browserify'
        filepath = code

        b = browserify filepath

        opts = {}
        opts.standalone = 'fantomo'
        opts.debug = true

        b.bundle opts, (err, src) =>
          if err
            console.error err
            return

          fn = (->
            browserify = (PLACEHOLDER)
            return fantomo arguments...
            ).toString().replace('PLACEHOLDER', src)
          eval "var fn = #{fn};"

          @evaluate fn, args...

      else
        throw "Injected code must be filename, dirname or inline javascript code"
