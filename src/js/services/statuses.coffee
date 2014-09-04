'use strict'

SK.factory 'StausesService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'statuses'
]
