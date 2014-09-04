'use strict'

SK.factory 'AssigneesService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'assignees'
]
