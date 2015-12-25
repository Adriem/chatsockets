# ==============================================================================
#  This file defines the angular service for socket.io. This service acts as a
#  wrapper that tells angular it must update rootScope's state on every callback
# ==============================================================================

module = angular.module 'ChatSockets'  # Retrieve module

module.factory 'socket', ($rootScope) ->
  socket = io.connect("http://localhost:3000")
  return {
    on: (event, callback) ->
      socket.on event, () ->
        args = arguments
        $rootScope.$apply( () -> callback.apply(socket, args) )
    emit: (event, data, callback) ->
      socket.emit event, data, () ->
        args = arguments
        $rootScope.$apply( () -> callback.apply(socket, args) )
  }
