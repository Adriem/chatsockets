module = angular.module('ChatSockets', ['ui.router'])  # Module definiton


module.config ($stateProvider, $urlRouterProvider) ->

  $stateProvider
    .state('chat', {
      url: '/chat'
      templateUrl: 'templates/chat.html'
    })
    .state('about', {
      url: '/about'
      templateUrl: 'templates/about.html'
    })

  $urlRouterProvider.otherwise('chat')


module.directive 'sidebar', ($location) ->
  templateUrl: 'templates/sidebar.html'
  scope: false
  link: (scope, element, attrs) ->
    scope.isActiveSection = (path) -> $location.path() == path


module.controller 'mainController', ($scope, $state, ChatSocketManager) ->

  $scope.chat =
    message     : null
    activeRoom  : 0
    roomList    : []
    username    : null
    onlineUsers : []

  ChatSocketManager.onConnectionEstablished (data) ->
    console.log(data)
    $scope.chat.username = data.username
    $scope.chat.onlineUsers = data.users
    $scope.chat.roomList[$scope.chat.activeRoom].messages = data.history

  ChatSocketManager.onMessageReceived (data) ->
    console.log(data)
    $scope.chat.roomList[$scope.chat.activeRoom].messages.push(data)

  ChatSocketManager.onUserJoin (data) ->
    console.log("User joined: #{data.user}")
    $scope.chat.roomList[$scope.chat.activeRoom].messages.push({
      body: "User #{data.user} joined the conversation"
    })
    $scope.chat.onlineUsers.push(data.user)

  ChatSocketManager.onUserLeave (data) ->
    console.log("User leave: #{data.user}")
    $scope.chat.roomList[$scope.chat.activeRoom].messages.push({
      body: "User #{data.user} left the conversation"
    })
    $scope.chat.onlineUsers.splice($scope.chat.onlineUsers.indexOf(data.user), 1)

  # Dummy data
  $scope.chat.roomList.push({
    name: "socket.io rulez!"
    unreads: 0
    messages : []
  }) #for i in [0...3]

  $scope.changeRoom = (targetRoom) ->
    $scope.chat.activeRoom = targetRoom
    $state.go('chat')

  $scope.sendMessage = () ->
    message =
      body       : $scope.chat.message
      author     : 'You'
      owned      : true
      waitingAck : true
      # date       : Date.now
    console.log(message)
    $scope.chat.message = null
    messageIndex = $scope.chat.roomList[$scope.chat.activeRoom]
      .messages.push(message) - 1
    ChatSocketManager.sendMessage message, () ->
      console.log('Message acquired!!')
      $scope.chat.roomList[$scope.chat.activeRoom]
        .messages[messageIndex].waitingAck = false
