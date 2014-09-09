'use strict'

SK.config [
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->

    $urlRouterProvider.otherwise '/'

    $stateProvider
    .state 'app',
      url: '/'
      abstract: true
      resolve:
        tasks: ['TasksService', (TasksService) -> TasksService.getList()]
        assignees: ['AssigneesService', (AssigneesService) -> AssigneesService.getList()]
        statuses: ['StatusesService', (StatusesService) -> StatusesService.getList()]
        labels: ['LabelsService', (LabelsService) -> LabelsService.getList()]
        milestones: ['MilestonesService', (MilestonesService) -> MilestonesService.getList()]
      views:
        '':
          controller: 'AppCtrl'
          templateUrl: 'tpls/application.html'
        'alerts@app':
          controller: 'AlertsCtrl'
          templateUrl: 'tpls/global/alerts.html'
    .state 'app.board',
      url: ''
      controller: 'BoardCtrl'
      templateUrl: 'tpls/board/page.html'
    .state 'app.assignees',
      url: 'assignees'
      controller: 'AssigneesCtrl'
      templateUrl: 'tpls/assignees.html'
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
