'use strict'

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
      controller: 'BoardCtrl'
      templateUrl: 'tpls/board.html'
      resolve:
        tasks: ['TasksService', (TasksService) -> TasksService.getList()]
    .state 'app.assignees',
      url: 'assignees'
      controller: 'AssigneesCtrl'
      templateUrl: 'tpls/assignees.html'
      resolve:
        assignees: ['AssigneesService', (AssigneesService) -> AssigneesService.getList()]
    .state 'app.statuses',
      url: 'statuses'
      controller: 'StatusesCtrl'
      templateUrl: 'tpls/statuses/page.html'
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
