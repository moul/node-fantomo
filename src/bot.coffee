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
