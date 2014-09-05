'use strict'

SK.controller 'AppCtrl', [
  '$scope'
  '$state'
  ($scope, $state) ->
    $scope.toolbar =
      createNew: ->
        console.log $state
]
