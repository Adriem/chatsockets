# ==============================================================================
#  This file contains the entry point for the server. Here are defined the
#  start and stop functions, which configure the router, the database
#  connection and the socket.io controller.
# ==============================================================================

http     = require 'http'            # Node HTTP library
socketIO = require 'socket.io'       # WebSocket library

config     = require './config'                        # Configuration file
router     = require './controller/router'             # Route manager middleware
socketCtrl = require './controller/socket-controller'  # Application routes

serverInstance = null  # Keep server instance in order to be able to close it later

start = (environment, port) ->
  server = http.Server(router)          # Create server
  io = socketIO(server)                 # Run socket.io
  socketCtrl.configure(io)              # Configure socket.io
  serverInstance = server.listen(port)  # Start listening

close = ->
  serverInstance.close()

module.exports =
  start : start
  close : close
