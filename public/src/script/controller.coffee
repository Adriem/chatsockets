# ==============================================================================
#  This file defines the main controller for the AngularJS application. This
#  controller handles the interaction between the ChatSockets API and the view.
# ------------------------------------------------------------------------------
#  This controller is global to the application, instead of local to the chat
#  view, because the chat keeps active in the background even when the user is
#  on another section.
# ==============================================================================

module = angular.module 'ChatSockets'  # Retrieve module

module.controller 'mainController', ($scope, $state, $location, ChatSocketManager) ->

  $scope.input =
    toggled  : false  # Hide sidebar
    message  : null   # Content of the message input
    username : null   # Given username

  $scope.chat =
    messages     : []  # Chat history
    unreadsCount : 0   # Unread messages count

  $scope.onlineUsers = []  # Online users list

  # Watch for changes on the path and remove unreads if the chat is open
  $scope.$watch(
    () -> $location.path(),
    () -> $scope.chat.unreadsCount = 0 if $location.path() is '/chat',
    true
  )

  # Set up listeners for ChatSocket manager
  ChatSocketManager.onConnectionEstablished (data) ->
    $scope.input.username = data.username
    $scope.onlineUsers    = data.users

  ChatSocketManager.onUserJoin (data) ->
    $scope.chat.unreadsCount++ if $location.path() isnt '/chat'
    $scope.chat.messages.push({
      body: "User #{data.user} joined the conversation"
      date: Date.now()
    })
    $scope.onlineUsers.push(data.user)

  ChatSocketManager.onUserLeave (data) ->
    $scope.chat.unreadsCount++ if $location.path() isnt '/chat'
    $scope.chat.messages.push({
      body: "User #{data.user} left the conversation"
      date: Date.now()
    })
    $scope.onlineUsers.splice($scope.onlineUsers.indexOf(data.user), 1)

  ChatSocketManager.onMessageReceived (data) ->
    $scope.chat.unreadsCount++ if $location.path() isnt '/chat'
    $scope.chat.messages.push(data)

  $scope.sendMessage = () ->
    message =
      body       : $scope.input.message
      author     : 'You'
      owned      : true
      waitingAck : true
    $scope.input.message = null
    messageIndex = $scope.chat.messages.push(message) - 1
    ChatSocketManager.sendMessage message, (error, data) ->
      $scope.chat.messages[messageIndex].waitingAck = false
      $scope.chat.messages[messageIndex].date = data.date
