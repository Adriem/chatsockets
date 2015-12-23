# ==============================================================================
#  This file defines the handler for the WebSockets protocol through socket.io
#  library. Note that socket.io must be started and provided outside this module
# ==============================================================================

socketIO = require 'socket.io'       # WebSocket library

configure = (server) ->
  io = socketIO(server)
  io.on 'connection', (socket) ->
    socket.emit('news', { hello: 'world' })
    socket.on 'other event', (data) ->
      console.log(data)
  return io

module.exports = configure
