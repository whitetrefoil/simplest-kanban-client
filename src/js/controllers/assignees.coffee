'use strict'

SK.controller 'AssigneesCtrl', [
  '$scope'
  'assignees'
  'AlertsService'
  ($scope, assignees, AlertsService) ->
    $scope.assignees = assignees
    $scope.save = (assignee) ->
      assignee.push()
      .then (args...) -> console.log 'success:', args
      .catch (args...) -> console.log 'fail:', args
    AlertsService.addAlert 'Assignees module initialized!', 'success', 'assignee'
]
