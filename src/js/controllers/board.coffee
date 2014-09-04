'use strict'

SK.controller 'BoardCtrl', [
  '$scope'
  'tasks'
  '$window'
  ($scope, tasks, $window) ->
    $scope.tasks = tasks
    $window.tasks = tasks
]
