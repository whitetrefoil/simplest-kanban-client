'use strict'

angular
.module 'simplestKanban'
.constant 'pushMethod', ->
  @save()
  .then (value) =>
    @_etag = value._etag
    value
