'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'tasks', (task) ->
      task.push = pushMethod
      task

    RestangularProvider.addElementTransformer 'tasks', true, (tasks) ->
      tasks.create = (args...) ->
        tasks.post(args...)
        .then (result) -> tasks.push result
      tasks
]

SK.factory 'TasksService', [
  'Restangular'
  (Restangular) ->
    Restangular.service 'tasks'
]
