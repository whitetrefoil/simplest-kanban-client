'use strict'

SK.controller 'AssigneesCtrl', [
  '$scope'
  'assignees'
  ($scope, assignees) ->
    $scope.assignees = assignees
    $scope.save = (assignee) ->
      assignee.push()
      .then (args...) -> console.log 'success:', args
      .catch (args...) -> console.log 'fail:', args
]
