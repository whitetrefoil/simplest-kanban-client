'use strict'

SK.factory 'TasksService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'tasks'
]
