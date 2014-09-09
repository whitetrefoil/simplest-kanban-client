'use strict'

SK.controller 'AppCtrl', [
  '$scope'
  'AlertsService'
  ($scope, AlertsService) ->
    $scope.create = ->
      $scope.$broadcast 'createButtonClicked'
    $scope.refresh = ->
      $scope.$broadcast 'refreshButtonClicked'
    $scope.alerts = []
    AlertsService.setAlertsScope($scope.alerts)
]
