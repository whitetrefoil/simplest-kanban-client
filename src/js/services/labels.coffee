'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'labels', (label) ->
      label.push = pushMethod
      label
]

SK.factory 'LabelsService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'labels'
]
