// Generated by CoffeeScript 1.6.3
(function() {
  var Fantomo, app, bot, debug;

  process.stdout.write('\u001B[2J\u001B[0;0f');

  debug = require('debug')('fantomo:examples:inject-inline');

  app = require('./express');

  app.listen(12345);

  Fantomo = require('..');

  bot = new Fantomo({
    verbose: true,
    url: 'http://127.0.0.1:12345/'
  });

  bot.on('open', function(path) {
    var callback, code;
    code = function(add, sub) {
      return 42 + add - sub;
    };
    callback = function(ret) {
      return debug("Returned " + ret);
    };
    return bot.inject(code, callback, 42, 15);
  });

}).call(this);