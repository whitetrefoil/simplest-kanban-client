define [
  'config'
  'backbone'
  'lodash'
], (
  Config
  Backbone
  _
) ->

  class BaseCollection extends Backbone.Collection
    fetch: ->
      if @promise? and @promise.state() is 'pending'
        @promise
      else
        @promise = super

    initialize: ->
      @_url = @url
      @url = ->
        if _.contains @_url, '://'
          @_url
        else
          Config.host + _.result @, '_url'

  return BaseCollection