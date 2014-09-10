'use strict'

angular.module 'simplestKanban'
.factory 'TasksService', [
  'createService'
  (createService) ->
    createService 'tasks'
]
