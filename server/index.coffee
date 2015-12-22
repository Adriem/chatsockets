# ==============================================================================
#  This file contains the entry point for the server. Here are defined the
#  start and stop functions, which configure the router and the database
#  connection.
# ==============================================================================

### DEPENDENCIES ###
# ------------------------------------------------------------------------------
express  = require 'express'         # Route management framework
morgan   = require 'morgan'          # Log requests to the console
parser   = require 'body-parser'     # Pull information from POST
override = require 'method-override' # Simulate DELETE and PUT
mongoose = require 'mongoose'        # MongoDB driver

config = require './config' # Configuration file

# START/STOP SERVER FUNCTIONS
# ------------------------------------------------------------------------------
server = null
start = (environment, port) ->
  # Configure express middleware (order does matter)
  router = express()
  router
    .use express.static(__dirname + '/public')
    .use morgan('dev') if environment isnt 'test'
    # .use parser.urlencoded({'extended':'false'})
    # .use parser.json({ type: 'application/vnd.api+json' })
    # .use override()
  # Set front-end routes
  router.get '*', (req, res) ->
    res.sendFile('index.html', {'root': 'public/dist'})
  # Connect to database and start listening
  mongoose.connect(config.database)
  server = router.listen(port)

close = ->
  server.close()
  mongoose.connection.close()

### MODULE EXPORTS ###
# ------------------------------------------------------------------------------
module.exports =
  start : start
  close : close
