express = require 'express'


module.exports = app = express()


app.get '/', (req, res) ->
  res.send 'Hello World'


app.get '/page.html', (req, res) ->
  res.send """
<html>
  <head>
    <title>Hello Title</h1>
  </head>
  <body>
    <h1>Hello Body</h1>
  </body>
</html>
  """