{EventEmitter} = require 'events'
phantom        = require 'phantom'

class module.exports.Browser extends EventEmitter
  constructor: (@options = {}, fn = (->)) ->
    @options.userAgent ?= 'NodeJS/Phantomo'
    @options.viewportSize ?= {width: 1546, height: 2048}
    @options.loadImages ?= false
    @options.verbose ?= false
    @options.excludeDomains ?= []
    @options.urlPrefix ?= ''
    @options.autoScreenshot ?= false
    @debug 'init'
    @init fn

  debug: (args...) =>
    if @options.verbose
      console.log "Browser>", args...

  evaluate: (script, fn, args...) =>
    @debug 'Evaluating: ', script.toString().replace(/\n/g, ' ')[0...100] + '...'
    @page.evaluate script, fn, args...

  init: (fn = null) =>
    phantom.create (@ph) =>
      @ph.createPage (@page) =>
        @page.set 'viewportSize',        @options.viewportSize
        @page.set 'loadImages',          @options.loadImages
        @page.set 'onConsoleMessage',    @onPageConsoleMessage
        @page.set 'onAlert',             @onPageAlert
        @page.set 'onError',             @onPageError
        @page.set 'onResourceRequested', @onResourceRequested
        @page.set 'onResourceReceived',  @onResourceReceived
        @page.set 'settings.userAgent',  @options.userAgent
        #@page.set 'Referer',             ''
        #page.addCookie 'name', 'value', 'host', -> console.log 'cookie added'
        @emit 'ready'
        do fn if fn

  onResourceRequested: (request) =>
    domain = request.url.split(/\//)[2]
    unless domain in @options.excludeDomains
      @debug 'Skipping Resource', request.url
      return false
    #@debug 'ResourceRequest>', request.id, request.url

  onResourceReceive: (response) =>
    @debug 'ResourceResponse>', response.id

  onPageError: (msg, trace) =>
    @debug 'Error> ', msg, trace

  onPageConsoleMessage: (msg, line, source) =>
    @debug 'Console> ', msg, line, source

  onPageAlert: (msg) =>
    @debug  'Alert> ', msg

  open: (path) =>
    url = "#{@options.urlPrefix}#{path}"
    @debug "url", url
    @page.open url, (status) =>
      return unless status
      @emit 'open', path
      @emit "open::#{path}"
      @debug "opened status", status
      if @options.autoScreenshot
        @page.render "last.png"