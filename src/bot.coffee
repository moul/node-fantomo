debug = require('debug') 'fantomo:lib:bot'

{Browser}       = require './browser'
{EventEmitter} = require 'events'

class module.exports.Bot extends EventEmitter
  constructor: (@options = {}) ->
    @options.browser ?= {}
    @options.verbose ?= false

    debug 'init'

    @init @options if @init?

    @browser = new Browser @options.browser

    @browser.on 'ready', =>
      debug 'ready'
      @emit  'ready'
      if @options.url?
        @browser.open @options.url

    @browser.on 'open', (args...) =>
      @on_open args... if @on_open?

    @open = @browser.open

  inject: (code, args...) ->
    switch typeof code
      when 'function'
        debug "Injecting inline function"
        @browser.evaluate code, args...
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

          @browser.evaluate fn, args...

      else
        throw "Injected code must be filename, dirname or inline javascript code"
