'use strict'

SK.controller 'BoardCtrl', [
  '$scope'
  'tasks'
  'statuses'
  'assignees'
  'milestones'
  'labels'
  ($scope, tasks, statuses, assignees, milestones, labels) ->

    refreshStatus = ->
      statuses.sort (a, b) -> a.order - b.order
      $scope.statuses = []

      _.forEach statuses.plain(), (status) ->
        output = _.pick status, ['code', 'name', 'cssClass', 'order']
        output.tasks = _.filter tasks, {status: status.code}
        $scope.statuses.push output

    $scope.$on 'refreshButtonClicked', ->
      _.invoke [tasks, statuses, assignees, milestones, labels], 'getList'

    $scope.$on 'taskMoveButtonClicked', (event, task, direction) ->
      # the `statuses` must already be sorted by order
      originalStatusCode = task.status
      currentStatusIndex = _.findIndex statuses, {code: originalStatusCode}
      targetStatus = statuses[currentStatusIndex + direction]
      if targetStatus?
        task.status = targetStatus.code
        refreshStatus()
        task.push().catch (reason) ->
          task.status = originalStatusCode
          refreshStatus()
          if reason.status is 412
            $scope.$emit 'errorMsg', 'Data in brower is out-of-date, please refresh before further operation!', reason
          else
            $scope.$emit 'errorMsg',  reason

    refreshStatus()
]
