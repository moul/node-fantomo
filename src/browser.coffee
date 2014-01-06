debug = require('debug') 'fantomo:lib:browser'
{EventEmitter} = require 'events'
phantom = require 'phantom'
require './patch'


class module.exports.Browser extends EventEmitter
  constructor: (@options={}, fn=null) ->
    @ready = false
    @options.userAgent ?= 'NodeJS/Phantomo'
    @options.viewportSize ?= {width: 1546, height: 2048}
    @options.loadImages ?= false
    @options.verbose ?= false
    @options.excludeDomains ?= []
    @options.urlPrefix ?= ''
    @options.autoScreenshot ?= false
    @options.referer ?= null
    @options.cookies ?= []
    @options.url ?= null
    debug 'init'
    @initBrowser fn

  evaluate: (script, args...) =>
    debug 'Evaluating: ', script.toString().replace(/\n/g, ' ')[0...100] + '...'
    @page.evaluate script, args...

  initBrowser: (fn=null) =>
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
        @page.set 'debug',        false
        if @options.referer
          @page.set 'Referer',           @options.referer
        for cookie in @options.cookies
          @setCookie cookie
        @ready = true
        @emit 'ready'
        if @options.url?
          @open @options.url
        do fn if fn

  setCookie: (cookie={}) =>
    @page.addCookie cookie.name, cookie.value, cookie.host, =>
      @emit 'cookie', cookie
      @emit "cookie::#{cookie.name}", cookie

  onResourceRequested: (request) =>
    domain = request.url.split(/\//)[2]
    unless domain in @options.excludeDomains
      #debug 'Skipping Resource', request.url
      return false
    #debug 'ResourceRequest>', request.id, request.url

  onResourceReceive: (response) =>
    debug 'ResourceResponse>', response.id

  onPageError: (msg, trace) =>
    debug 'Error> ', msg, trace

  onPageConsoleMessage: (msg, line, source) =>
    if line and source
      debug 'Console> ', msg, line, source
    else
      debug 'Console> ', msg

  onPageAlert: (msg) =>
    debug 'Alert> ', msg

  open: (path) =>
    url = "#{@options.urlPrefix}#{path}"
    debug "open", "url=#{url}"
    @page.open url, (status) =>
      return unless status
      debug "open", "status=#{status}"
      @emit 'open', path
      @emit "open::#{path}"
      if @options.autoScreenshot
        @page.render "last.png"
