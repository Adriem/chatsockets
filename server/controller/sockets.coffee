# ==============================================================================
#  This file defines the handler for the WebSockets protocol through socket.io
#  library.
# ==============================================================================

socketIO = require 'socket.io'  # WebSocket library
Moniker  = require 'moniker'    # Random name generator

users = []
messages = []

configure = (server) ->

  # Launch socket.io and set up to call disconnect event on browser unload
  io = socketIO(server, { 'sync disconnect on unload': true })

  io.on 'connection', (socket) ->

    username = Moniker.choose() # Generate random user name
    users.push(username)        # Add new user to users list
    console.log("User joined: #{username}")
    # Send status
    socket.emit('CONNECTION_ESTABLISHED', {
      username : username
      users    : users
      history  : messages
    })
    # Notice other users a new user has joined
    socket.broadcast.emit('USER_JOIN', { user: username })

    socket.on 'disconnect', () ->
      console.log("User leaved: #{username}")
      users.splice(users.indexOf(username), 1)
      socket.emit('USER_LEAVE', { user: username })

    socket.on 'MESSAGE_SENT', (data, ackCallback) ->
      data.author = username
      # data.date   = Date.now()
      delete data.waitingAck
      delete data.owned
      console.log(data)
      socket.broadcast.emit('MESSAGE_RECEIVED', data)
      ackCallback(null, data)

    # setInterval(() ->
      # socket.emit('MESSAGE_RECEIVED', {
        # author: "Timer"
        # body: "Dummy"
      # })
    # , 5000)

  return io

module.exports = configure
