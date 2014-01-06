#!/usr/bin/env coffee


# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'


debug = require('debug') 'fantomo:examples:bot-debug'


Fantomo    = require '..'


bot = new Fantomo
  verbose: true


bot.on 'ready', ->
  debug 'bot is ready'
  @open 'http://moul.github.io/'


bot.on 'open', (path) ->
  debug "browser is open (#{path})"
