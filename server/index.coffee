# ==============================================================================
#  This file contains the entry point for the server. Here are defined the
#  start and stop functions, which configure the router, the database
#  connection and the socket.io controller.
# ==============================================================================

http = require 'http'  # Node HTTP library

config  = require './config'   # Configuration file
router  = require './router'   # Route manager middleware
sockets = require './sockets'  # socket.io manager

serverInstance = null  # Keep server instance in order to be able to close it later

start = (port) ->
  server         = http.Server(router)  # Create server
  io             = sockets(server)      # Run socket.io
  serverInstance = server.listen(port)  # Start listening

close = ->
  serverInstance.close()

module.exports =
  start : start
  close : close
