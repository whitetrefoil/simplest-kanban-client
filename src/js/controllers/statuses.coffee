'use strict'

angular
.module 'simplestKanban'
.controller 'StatusesCtrl', [
  '$scope'
  'StatusesService'
  ($scope, StatusesService) ->
    $scope.statuses = StatusesService.getList().$object
]
