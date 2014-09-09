'use strict'

SK.controller 'BoardCtrl', [
  '$scope'
  'tasks'
  'statuses'
  ($scope, tasks, statuses) ->
    $scope.statuses = []
    statusesIndex = {}

    _.forEach statuses.plain(), (status, i) ->
      $scope.statuses[i] = _.pick status, ['code', 'name', 'cssClass', 'order']
      $scope.statuses[i].tasks = []
      statusesIndex[status.code] = i

    tasks.forEach (task) ->
      $scope.statuses[statusesIndex[task.status]].tasks.push task
]
