'use strict'

SK.config [
  'RestangularProvider',
  (RestangularProvider) ->

    RestangularProvider.extendModel 'assignees', (assignee) ->
      assignee.push = ->
        @save()
        .then (value) =>
          @_etag = value._etag
          value

      assignee
]

SK.factory 'AssigneesService', [
  'Restangular'
  (Restangular) ->
    Restangular.all 'assignees'
]
