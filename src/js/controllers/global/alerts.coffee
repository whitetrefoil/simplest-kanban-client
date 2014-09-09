angular.module 'simplestKanban'
.controller 'AlertsCtrl', [
  '$scope'
  ($scope) ->
    $scope.close = (index) ->
      $scope.alerts.splice index, 1
]
