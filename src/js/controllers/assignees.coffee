'use strict'

SK.controller 'AssigneesCtrl', [
  '$scope'
  'assignees'
  '$window'
  ($scope, assignees, $window) ->
    $scope.assignees = assignees
    $window.assignees = assignees
]
