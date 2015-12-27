# ==============================================================================
#  This file defines the handler for the WebSockets protocol through socket.io
#  library.
# ==============================================================================

socketIO = require 'socket.io'       # WebSocket library

configure = (server) ->
  io = socketIO(server)
  io.on 'connection', (socket) ->
    socket.emit('news', { hello: 'world' })
    socket.on 'other event', (data) ->
      console.log(data)
    setInterval(() ->
      socket.emit('MESSAGE_RECEIVED', {
        author: "Timer"
        body: "Dummy"
      })
    , 1000)
  return io

module.exports = configure
