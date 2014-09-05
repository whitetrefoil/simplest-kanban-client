'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'statuses', (status) ->
      status.push = pushMethod
      status
]

SK.factory 'StatusesService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'statuses'
]
