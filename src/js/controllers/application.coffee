'use strict'

SK.controller 'AppCtrl', [
  '$scope'
  '$state'
  ($scope) ->
    $scope.create = ->
      $scope.$broadcast 'createButtonClicked'
    $scope.refresh = ->
      $scope.$broadcast 'refreshButtonClicked'
]
