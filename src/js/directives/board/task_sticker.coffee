'use strict'

angular.module 'simplestKanban'
.directive 'taskSticker', [
  ->
    restrict: 'A'
    templateUrl: 'tpls/board/task_sticker.html'
    scope:
      task: '='
      class: '=panelClass'
      editTask: '=editFn'
    controller: [
      '$scope'
      ($scope) ->
        $scope.moveLeft = -> $scope.$emit 'taskMoveButtonClicked', $scope.task, -1
        $scope.moveRight = -> $scope.$emit 'taskMoveButtonClicked', $scope.task, 1
    ]
]
