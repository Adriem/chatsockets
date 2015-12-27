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

  # Expose factory methods
  return {
    on: subscribe
    emit: publish
  }


module.service 'ChatSocketManager', (Socket) ->

  Socket.on 'news', (data) ->
    console.log(data)
    Socket.emit('other event', { my: 'data' })

  onMessageReceived = (callback) ->
    Socket.on('MESSAGE_RECEIVED', callback)

  sendMessage = (message, callback) ->
    Socket.emit('MESSAGE_SENT', message, callback)

  return {
    onMessageReceived : onMessageReceived
    sendMessage       : sendMessage
  }

