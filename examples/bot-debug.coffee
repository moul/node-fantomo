#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

Fantomo    = require '..'

bot = new Fantomo
  verbose: true
  browser:
    verbose: true

bot.on 'ready', ->
  console.log 'bot is ready'
  setTimeout (=> @open 'http://moul.github.io/'), 3000

bot.on 'open', ->
  console.log 'opened'
