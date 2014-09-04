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
      switch operation
        when 'getList'
          dataBody = data._items
          metaData = _.pick data, (val, key) ->
            key.startsWith('_') and key isnt '_items'
          _.assign dataBody, metaData
        else
          dataBody = data
      dataBody

    RestangularProvider.addRequestInterceptor (elem) ->
      _.omit elem, (val, key) -> key.startsWith('_')
]
