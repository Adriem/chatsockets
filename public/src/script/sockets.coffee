# ==============================================================================
#  This file defines the angular service for socket.io. and the angular service
#  that will handle ChatSockets application protocol over socket.io
# ==============================================================================

module = angular.module 'ChatSockets'  # Retrieve module


module.factory 'Socket', ($rootScope) ->

  # Connect to socket.io when loaded
  socket = io.connect("http://localhost:3000")

  # Subscribe to a socket.io event and update $rootScope when
  # that event is received
  subscribe = (event, callback) ->
    socket.on event, () ->
      args = arguments
      $rootScope.$apply( () -> callback.apply(socket, args) )

  # Publish a socket.io event and it's data. If a callback is provided, update
  # $rootScope when it is called
  publish = (event, data, callback) ->
    socket.emit event, data, () ->
      args = arguments
      $rootScope.$apply( () -> callback.apply(socket, args) )

  # Public interface
  return {
    on: subscribe
    emit: publish
  }


module.service 'ChatSocketManager', (Socket) ->

  # Add a callback to be called on connection established
  onConnectionEstablished: (callback) ->
    Socket.on('CONNECTION_ESTABLISHED', callback)

  # Add a callback for received messages
  onMessageReceived: (callback) ->
    Socket.on('MESSAGE_RECEIVED', callback)

  # Send a message
  sendMessage: (message, callback) ->
    Socket.emit('MESSAGE_SENT', message, callback)

  # Add a callback for user connections
  onUserJoin: (callback) ->
    Socket.on('USER_JOIN', callback)

  # Add a callback for user disconnections
  onUserLeave: (callback) ->
    Socket.on('USER_LEAVE', callback)
