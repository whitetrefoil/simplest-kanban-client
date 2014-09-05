'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'tasks', (task) ->
      task.push = pushMethod
      task
]

SK.factory 'TasksService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'tasks'
]
