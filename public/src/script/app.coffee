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

  $scope.activeRoom  = 0
  $scope.roomList    = []
  $scope.onlineUsers = []

  ChatSocketManager.onMessageReceived (data) ->
    console.log(data)
    $scope.roomList[$scope.activeRoom].messages.push(data)
    return null

  room = {
    name: "AngularJS"
    unreads: 5
    messages : []
  }
  room.messages.push({
    author: 'John-Doe'
    date: i
    body: """
      Lorem ipsum dolor sit amet, consectetur adipisicing
      elit. Aspernatur mollitia maxime facere quae cumque.
    """
  }) for i in [0...15]
  $scope.roomList.push(room) for i in [0...3]
  $scope.onlineUsers.push('User ' + i) for i in [0...5]

  $scope.changeRoom = (targetRoom) ->
    $scope.activeRoom = targetRoom
    $state.go('chat')

  $scope.sendMessage = (message) -> #TODO

  return null
