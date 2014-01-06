#!/usr/bin/env coffee


# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'


debug = require('debug') 'fantomo:examples:inject-dir'
app = require('./express')
app.listen 12345


Fantomo    = require '..'


bot = new Fantomo
  verbose: true
  url: 'http://127.0.0.1:12345/'


bot.on 'open', (path) ->
  debug "browser is open (#{path})"

  callback = (ret) ->
    console.log "callback: ret=#{ret}"

  bot.inject './inject/index', callback, 1, 2, 3
