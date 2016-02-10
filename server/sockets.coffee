# ==============================================================================
#  This file defines the handler for the WebSockets protocol through socket.io
#  library.
# ==============================================================================

socketIO = require 'socket.io'  # WebSocket library
Moniker  = require 'moniker'    # Random name generator

users = []  # Array to store online users

configure = (server) ->

  io = socketIO(server)  # Launch socket.io
  io.on 'connection', (socket) ->

    # Register new user
    username = Moniker.choose()  # Generate random user name
    users.push(username)         # Add new user to users list

    console.log "#{getDate()} - User joined: #{username}"

    # Send current status to new user
    socket.emit('CONNECTION_ESTABLISHED', {
      username : username
      users    : users
    })

    # Notice other users that the new user has joined
    socket.broadcast.emit('USER_JOIN', { user: username })

    # Set up a listener that broadcasts every message received by this
    # connection to all the users but the author of the message.
    socket.on 'MESSAGE_SENT', (data, ackCallback) ->
      data.author = username
      data.date   = Date.now()
      delete data.waitingAck
      delete data.owned
      console.log "#{getDate()} - Message received from #{data.author}: #{data.body}"
      socket.broadcast.emit('MESSAGE_RECEIVED', data)
      ackCallback(null, data)

    # Set up a listener that unregisters the user when he or she disconnects
    socket.on 'disconnect', () ->
      console.log "#{getDate()} - User leaved: #{username}"
      users.splice(users.indexOf(username), 1)
      socket.broadcast.emit('USER_LEAVE', { user: username })

  return io

module.exports = configure

# Private helper to timestamp logs
getDate = () -> new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '')
