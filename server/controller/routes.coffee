# ==============================================================================
#  This file defines the routes the user will be able to connect through HTTP
# ==============================================================================

express = require 'express'

routes = express.Router()
routes
  .get('*', (req, res) -> res.sendFile('index.html', {'root': 'public/dist'}))

module.exports = routes
