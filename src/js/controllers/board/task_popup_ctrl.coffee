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
      labels: []
    }

    $scope.statuses = statuses.plain()

    $scope.cancel = -> $modalInstance.dismiss 'cancel'

    $scope.save = ->
      $scope.saveStatus = 'saving'
      saving = if isNew
        if _.isEmpty $scope.task.assignee then delete $scope.task.assignee
        tasks.post $scope.task
      else
        originalTask = _.pick task, _.keys($scope.task)
        _.extend task, $scope.task
        if _.isEmpty task.assignee then delete task.assignee
        task.push()
      saving
      .then (result) ->
        $modalInstance.close(result)
      .catch ->
        _.extend task, originalTask
        $scope.saveStatus = 'failed'

    $scope.delete = ->
      $scope.deleteStatus = 'saving'
      task.remove()
      .then ->
        $modalInstance.close()
      .catch ->
        $scope.deleteStatus = 'failed'
]
