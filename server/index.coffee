# ==============================================================================
#  This file contains the entry point for the server. Here are defined the
#  start and stop functions, which configure the router, the database
#  connection and the socket.io controller.
# ==============================================================================

express  = require 'express'         # Route management framework
morgan   = require 'morgan'          # Log requests to the console
http     = require 'http'            # Node HTTP library
socketIO = require 'socket.io'       # WebSocket library

config     = require './config'                        # Configuration file
routes     = require './controller/routes'             # Application routes
socketCtrl = require './controller/socket-controller'  # Application routes

serverInstance = null  # Keep server instance in order to be able to close it later

start = (environment, port) ->
  # Express configuration (order does matter)
  router = express()
  router.use morgan('dev') if environment isnt 'test' # Log requests to console
  router
    .use express.static(__dirname + '/public')
    .use routes
  # Start server
  server = http.Server(router)          # Create server
  io = socketIO(server)                 # Run socket.io
  serverInstance = server.listen(port)  # Start listening
  socketCtrl.configure(io)              # Configure socket.io

close = ->
  serverInstance.close()

module.exports =
  start : start
  close : close
