'use strict'

angular.module 'simplestKanban'
.controller 'TaskPopupCtrl', [
  '$scope', '$modalInstance', 'task'
  'tasks', 'statuses', 'assignees', 'milestones', 'labels'
  ($scope, $modalInstance, task
   tasks, statuses, assignees, milestones, labels) ->
    isNew = $scope.isNew = !task?
    $scope.title = if isNew then 'New Task' else 'Edit Task'

    $scope.isConfirmingDeleting = false
    $scope.cancelDeleting = -> $scope.isConfirmingDeleting = false
    $scope.confirmDeleting = -> $scope.isConfirmingDeleting = true

    $scope.task = if task? then task.plain() else {
      status: statuses[0].code
    }

    $scope.statuses = statuses.plain()

    $scope.cancel = -> $modalInstance.dismiss 'cancel'

    $scope.save = ->
      console.log $scope.task.status

    ###
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
    ###
]
