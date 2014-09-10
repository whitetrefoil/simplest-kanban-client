'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'statuses', (status) ->
      status.push = pushMethod
      status

    RestangularProvider.addElementTransformer 'statuses', true, (statuses) ->
      statuses.create = (args...) ->
        statuses.post(args...)
        .then (result) -> statuses.push result
      statuses
]

SK.factory 'StatusesService', [
  'Restangular'
  (Restangular) ->
    Restangular.service 'statuses'
]
