class SK.BaseModel extends Backbone.Model
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
        SK.Config.host + _.result @, '_url'
