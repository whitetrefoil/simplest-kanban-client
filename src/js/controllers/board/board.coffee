'use strict'

SK.controller 'BoardCtrl', [
  '$scope', '$rootScope', '$q', '$modal'
  'tasks', 'statuses', 'assignees', 'milestones', 'labels'
  ($scope, $rootScope, $q, $modal,
   tasks, statuses, assignees, milestones, labels) ->

    openTaskPopup = (task = null) ->
      $modal.open
        windowClass: 'popup'
        backdrop: 'static'
        controller: 'TaskPopupCtrl'
        templateUrl: 'tpls/board/task_popup.html'
        resolve:
          task: -> task
          tasks: -> tasks
          statuses: -> statuses
          labels: -> labels
          assignees: -> assignees
          milestones: -> milestones
      .result

    refreshStatus = ->
      statuses.sort (a, b) -> a.order - b.order
      $scope.statuses = []

      _.forEach statuses.plain(), (status) ->
        output = _.pick status, ['code', 'name', 'cssClass', 'order']
        output.tasks = _.filter tasks, {status: status.code}
        $scope.statuses.push output


    $scope.$on 'createButtonClicked', ->
      openTaskPopup()
      .then (newTask) ->
        console.log newTask


    $scope.$on 'refreshButtonClicked', ->
      promises = _.invoke [tasks, statuses, assignees, milestones, labels], 'getList'
      $q.all(promises).then (args...)->
        [tasks, statuses, assignees, milestones, labels] = args[0]
        refreshStatus()

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
