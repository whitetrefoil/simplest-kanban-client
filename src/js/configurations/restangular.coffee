'use strict'

SK.config [
  'RestangularProvider'
  (RestangularProvider) ->
    RestangularProvider.setBaseUrl '/api'
    RestangularProvider.setRestangularFields
      id: '_id'
      selfLink: '_links.self.href'
      etag: '_etag'

    RestangularProvider.addResponseInterceptor (data, operation) ->
      setEtag = (elem) ->
        #elem.restangularEtag = elem._etag
        elem
      switch operation
        when 'getList'
          dataBody = data._items.map setEtag
          metaData = _.pick data, (val, key) ->
            key.startsWith('_') and key isnt '_items'
          _.assign dataBody, metaData
        else
          dataBody = setEtag(data)
      dataBody

    RestangularProvider.addRequestInterceptor (elem) ->
      _.omit elem, (val, key) -> key.startsWith('_')
]
