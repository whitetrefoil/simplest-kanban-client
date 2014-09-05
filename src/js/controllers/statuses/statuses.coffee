'use strict'

StatusPopupCtrl = [
  '$scope', '$modalInstance', 'isNew', 'title', 'statuses'
  ($scope, $modalInstance, isNew, title, statuses) ->
    $scope.isNew = isNew
    $scope.title = title
    window.statuses = statuses
    if isNew is true
      $scope.model = {}
    $scope.cancel = -> $modalInstance.dismiss 'cancel'
    $scope.save = ->
      $scope.saveStatus = 'saving'
      statuses.post $scope.model
      .then (result) ->
        statuses.push result
        $modalInstance.close(result)
      .catch (reason) ->
        $scope.saveStatus = 'failed'
]


angular
.module 'simplestKanban'
.controller 'StatusesCtrl', [
  '$scope'
  'StatusesService'
  '$modal'
  ($scope, StatusesService, $modal) ->
    $scope.statuses = StatusesService.getList().$object
    $scope.toolbar.createNew = ->
      $modal.open
        windowClass: 'popup'
        backdrop: 'static'
        controller: StatusPopupCtrl
        templateUrl: 'tpls/statuses/popup.html'
        resolve:
          isNew: -> true
          title: -> 'New Status'
          statuses: -> $scope.statuses
]
