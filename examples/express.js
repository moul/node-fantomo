// Generated by CoffeeScript 1.6.3
(function() {
  var app, express;

  express = require('express');

  module.exports = app = express();

  app.get('/', function(req, res) {
    return res.send('Hello World');
  });

  app.get('/page.html', function(req, res) {
    return res.send("<html>\n  <head>\n    <title>Hello Title</h1>\n  </head>\n  <body>\n    <h1>Hello Body</h1>\n  </body>\n</html>");
  });

}).call(this);
