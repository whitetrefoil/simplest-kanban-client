'use strict'

angular.module 'simplestKanban'
.factory 'AssigneesService', [
  'createService'
  (createService) ->
    createService 'assignees'
]
