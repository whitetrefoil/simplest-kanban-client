'use strict'

angular
.module 'simplestKanban'
.constant 'pushMethod', ->
  # orz...
  realThis = @.save.__bindData__[4]
  @save()
  .then (value) ->
    realThis._etag = value._etag
    value
