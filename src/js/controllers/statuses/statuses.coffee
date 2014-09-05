'use strict'

StatusPopupCtrl = [
  '$scope', '$modalInstance', 'title', 'status', 'statuses'
  ($scope, $modalInstance, title, status, statuses) ->
    isNew = !status?

    $scope.isConfirmingDeleting = false
    $scope.cancelDeleting = -> $scope.isConfirmingDeleting = false
    $scope.confirmDeleting = -> $scope.isConfirmingDeleting = true

    $scope.isNew = isNew
    $scope.title = title

    if $scope.isNew is true
      $scope.model = {
        cssClass: 'default'
      }
    else
      $scope.model = status

    $scope.cancel = -> $modalInstance.dismiss 'cancel'

    $scope.save = ->
      $scope.saveStatus = 'saving'
      saving = if isNew
        statuses.post $scope.model
      else
        status.put()
      saving
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
          _.extend status, newStatus
        else
          _.remove statuses, status
]
