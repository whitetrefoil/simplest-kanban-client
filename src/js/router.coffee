SK.config [
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->


    $urlRouterProvider.otherwise '/'

    $stateProvider
    .state 'app',
      url: '/'
      controller: 'AppCtrl'
      templateUrl: 'tpls/application.html'
      abstract: true
    .state 'app.board',
      url: ''
      template: 'board - TBD'
    .state 'app.assignees',
      url: 'assignees'
      template: 'assignees - TBD'
    .state 'app.milestones',
      url: 'milestones'
      template: 'milestones - TBD'
    .state 'app.labels',
      url: 'labels'
      template: 'labels - TBD'
    .state 'app.help',
      url: 'help'
      templateUrl: 'tpls/help.html'
      controller: 'HelpCtrl'
]
