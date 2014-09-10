'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'assignees', (assignee) ->
      assignee.push = pushMethod
      assignee

    RestangularProvider.addElementTransformer 'assignees', true, (assignees) ->
      assignees.create = (args...) ->
        assignees.post(args...)
        .then (result) -> assignees.push result
      assignees
]

SK.factory 'AssigneesService', [
  'Restangular'
  (Restangular) ->
    Restangular.service 'assignees'
]
