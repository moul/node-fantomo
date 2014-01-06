#!/usr/bin/env coffee


# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'


debug = require('debug') 'fantomo:examples:cache-url'
app = require('./express')
app.listen 12345


Fantomo    = require '..'


bot = new Fantomo
  verbose: true
  url: 'http://127.0.0.1:12345/'


bot.on 'open', (path) ->
  debug "browser is open (#{path})"

  #bot.cache_url 'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js'
  bot.cache_url 'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.js', (err, filepath) ->
    if err
      throw err

    bot.inject filepath, ->
      debug 'jQuery is injected'
      bot.inject ->
        $ = fantomo
        console.log $('body').text()
