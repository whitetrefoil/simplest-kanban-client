'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'assignees', (assignee) ->
      assignee.push = pushMethod
      assignee
]

SK.factory 'AssigneesService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'assignees'
]
