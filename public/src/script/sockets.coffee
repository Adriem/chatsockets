# ==============================================================================
#  This file defines some AngularJS providers to handle socket.io on the client
#  within AngularJS
# ==============================================================================

module = angular.module 'ChatSockets'  # Retrieve module

# ------------------------------------------------------------------------------
#  AngularJS provider for socket.io that wraps socket.io.js within Angular.
# ------------------------------------------------------------------------------
module.factory 'Socket', ($rootScope) ->

  # Connect to socket.io when loaded
  socket = io.connect()

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

# ------------------------------------------------------------------------------
#  AngularJS service that encapsulates ChatSockets application protocol
#  over socket.io through the service defined previously.
# ------------------------------------------------------------------------------
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
