'use strict'

SK.controller 'AppCtrl', [
  '$scope'
  ($scope) ->
    $scope.create = ->
      $scope.$broadcast 'createButtonClicked'
    $scope.refresh = ->
      $scope.$broadcast 'refreshButtonClicked'
    $scope.alerts = []
    $scope.$on 'errorMsg', (event, msg) ->
      $scope.alerts.push
        type: 'danger'
        msg: msg
]
