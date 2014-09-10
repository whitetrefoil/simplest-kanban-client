'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'milestones', (milestone) ->
      milestone.push = pushMethod
      milestone

    RestangularProvider.addElementTransformer 'milestones', true, (milestones) ->
      milestones.create = (args...) ->
        milestones.post(args...)
        .then (result) -> milestones.push result
      milestones
]

SK.factory 'MilestonesService', [
  'Restangular'
  (Restangular) ->
    Restangular.service 'milestones'
]
