'use strict'

StatusPopupCtrl = [
  '$scope', '$modalInstance', 'title', 'status', 'statuses'
  ($scope, $modalInstance, title, status, statuses) ->
    $scope.isConfirmingDeleting = false
    $scope.cancelDeleting = -> $scope.isConfirmingDeleting = false
    $scope.confirmDeleting = -> $scope.isConfirmingDeleting = true

    $scope.isNew = !status?
    $scope.title = title

    if $scope.isNew is true
      $scope.model = {}
    else
      $scope.model = status

    $scope.cancel = -> $modalInstance.dismiss 'cancel'
    $scope.save = ->
      $scope.saveStatus = 'saving'
      statuses.post $scope.model
      .then (result) ->
        $modalInstance.close(result)
      .catch ->
        $scope.saveStatus = 'failed'

    $scope.delete = ->
      $scope.deleteStatus = 'saving'
      status.remove()
      .then ->
        $modalInstance.close()
      .catch ->
        $scope.deleteStatus = 'failed'
]


angular
.module 'simplestKanban'
.controller 'StatusesCtrl', [
  '$scope'
  'statuses'
  '$modal'
  ($scope, statuses, $modal) ->
    $scope.statuses = statuses
    $scope.toolbar.createNew = ->
      $modal.open
        windowClass: 'popup'
        backdrop: 'static'
        controller: StatusPopupCtrl
        templateUrl: 'tpls/statuses/popup.html'
        resolve:
          status: -> null
          title: -> 'New Status'
          statuses: -> statuses
      .result.then (newStatus) ->
        statuses.push newStatus

    $scope.editStatus = (status) ->
      $modal.open
        windowClass: 'popup'
        backdrop: 'static'
        controller: StatusPopupCtrl
        templateUrl: 'tpls/statuses/popup.html'
        resolve:
          status: status.clone
          title: -> "Editing #{status.name}"
          statuses: -> statuses
      .result.then (newStatus) ->
        if newStatus?
          _.assign status, newStatus
        else
          _.remove statuses, status
]
