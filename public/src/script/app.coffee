# ==============================================================================
#  This file is the entry point for the angular application, here is defined
#  the module and its dependencies. This file defines the routes for the
#  front-end application and the sidebar directive too.
# ==============================================================================

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
  replace     : true   # Replace the element
  scope       : false  # Inherit parent scope
  templateUrl : 'templates/sidebar.html'
