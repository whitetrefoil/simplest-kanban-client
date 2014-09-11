'use strict'

angular.module 'simplestKanban'
.factory 'createService', [
  'Restangular'
  (Restangular) ->
    (name) ->
      Restangular.withConfig (RestangularConfigurer) ->
        RestangularConfigurer.extendModel name, (elem) ->
          elem.push = ->
            elem.save()
            .then (result) ->
              elem._etag = result._etag if result._etag?
          elem

        RestangularConfigurer.addElementTransformer name, true, (collection) ->
          collection.create = (args...) ->
            collection.post(args...)
            .then (result) -> collection.push result
          collection

      .service name
]
