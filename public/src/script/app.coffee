module = angular.module('ChatSockets', [])  # Module definiton

module.controller 'mainController', ($scope, socket) ->
  socket.on 'news', (data) ->
    console.log(data)
    socket.emit('other event', { my: 'own data' })


