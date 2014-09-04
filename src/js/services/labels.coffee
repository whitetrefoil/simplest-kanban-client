'use strict'

SK.factory 'LabelsService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'labels'
]
