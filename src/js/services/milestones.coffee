'use strict'

SK.config [
  'RestangularProvider'
  'pushMethod'
  (RestangularProvider, pushMethod) ->

    RestangularProvider.extendModel 'milestones', (milestone) ->
      milestone.push = pushMethod
      milestone
]

SK.factory 'MilestonesService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'milestones'
]
