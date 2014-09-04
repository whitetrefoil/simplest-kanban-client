'use strict'

SK.factory 'MilestonesService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'milestones'
]
