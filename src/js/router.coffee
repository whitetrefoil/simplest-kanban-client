SK.config [
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->


    $urlRouterProvider.otherwise '/help'

    $stateProvider
    .state 'help',
      url: '/help'
      templateUrl: 'tpls/help.html'
      controller: 'HelpCtrl'

]
