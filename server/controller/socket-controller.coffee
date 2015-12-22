configure = (io) ->
  io.on 'connection', (socket) ->
    socket.emit('news', { hello: 'world' })
    socket.on 'other event', (data) ->
      console.log(data)

module.exports =
  configure : configure
