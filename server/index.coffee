# ==============================================================================
#  This file contains the entry point for the server. Here are defined the
#  start and stop functions, which configure the router and the database
#  connection.
# ==============================================================================

express  = require 'express'         # Route management framework
morgan   = require 'morgan'          # Log requests to the console
http     = require 'http'            # Node HTTP library
socketIO = require 'socket.io'       # WebSocket library

config     = require './config'                       # Configuration file
routes     = require './controller/routes'            # Application routes
socketCtrl = require './controller/socket-controller' # Application routes

# START/STOP SERVER FUNCTIONS
# ------------------------------------------------------------------------------
serverInstance = null  # Server instance

start = (environment, port) ->
  # Express configuration (order does matter)
  router = express()
  router.use morgan('dev') if environment isnt 'test'
  router
    .use express.static(__dirname + '/public')
    .use routes
  # Start server
  server = http.Server(router)          # Create server
  io = socketIO(server)                 # Run socket.io
  serverInstance = server.listen(port)  # Start listening
  # Socket.io configuration
  # io.on 'connection', (socket) ->
    # socket.emit('news', { hello: 'world' })
    # socket.on 'other event', (data) ->
      # console.log(data)
  socketCtrl.configure(io)

close = ->
  serverInstance.close()

### MODULE EXPORTS ###
# ------------------------------------------------------------------------------
module.exports =
  start : start
  close : close
