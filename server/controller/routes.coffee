express = require 'express'

routes = express.Router()
routes.get '/greet', (req, res) -> res.send('Hello, sir!')
routes.get '*', (req, res) ->
  res.sendFile('index.html', {'root': 'public/dist'})

module.exports = routes
