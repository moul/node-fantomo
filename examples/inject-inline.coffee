#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

debug = require('debug') 'fantomo:examples:bot-debug'
app = require('./express')
app.listen 12345

Fantomo    = require '..'

bot = new Fantomo
  verbose: true
  browser:
    verbose: true

bot.on 'ready', ->
  @open 'http://127.0.0.1:12345/'

bot.browser.on 'open', (path) ->
  code = (add, sub) ->
    return 42 + add - sub

  callback = (ret) ->
    debug "Returned #{ret}"

  bot.inject code, callback, 42, 15
