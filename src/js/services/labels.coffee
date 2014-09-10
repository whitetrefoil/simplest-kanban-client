'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'labels', (label) ->
      label.push = pushMethod
      label

    RestangularProvider.addElementTransformer 'labels', true, (labels) ->
      labels.create = (args...) ->
        labels.post(args...)
        .then (result) -> labels.push result
      labels
]

SK.factory 'LabelsService', [
  'Restangular'
  (Restangular) ->
    Restangular.service 'labels'
]
