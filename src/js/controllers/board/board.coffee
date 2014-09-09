'use strict'

SK.controller 'BoardCtrl', [
  '$scope'
  'tasks'
  'statuses'
  ($scope, tasks, statuses) ->
    $scope.statuses = {}
    _.forEach statuses.plain(), (status) ->
      $scope.statuses[status.code] = _.pick status, ['name', 'cssClass']
      $scope.statuses[status.code].tasks = []

    tasks.forEach (task) ->
      $scope.statuses[task.status].tasks.push task
]
