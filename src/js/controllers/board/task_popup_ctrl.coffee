'use strict'

angular.module 'simplestKanban'
.controller 'TaskPopupCtrl', [
  '$scope', '$modalInstance', '$q', 'task'
  'tasks', 'statuses', 'assignees', 'milestones', 'labels'
  ($scope, $modalInstance, $q, task
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
    $scope.assignees = assignees.plain()

    $scope.cancel = -> $modalInstance.dismiss 'cancel'

    $scope.save = ->
      $scope.saveStatus = 'saving'
      originalTask = null
      savingAssignee = null
      if _.isEmpty $scope.task.assignee
        delete $scope.task.assignee
      else if _.find(assignees, ({name: $scope.task.assignee})) is undefined
        savingAssignee = assignees.post({name: $scope.task.assignee})
        .then (result) -> assignees.push result
      $q.when(savingAssignee)
      .then ->
        if isNew
          tasks.post $scope.task
        else
          originalTask = _.pick task, _.keys($scope.task)
          _.extend task, $scope.task
          task.push()

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
