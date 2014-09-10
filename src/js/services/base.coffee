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
            .then (result) -> _.extend elem, result
          elem

        RestangularConfigurer.addElementTransformer name, true, (collection) ->
          collection.create = (args...) ->
            collection.post(args...)
            .then (result) -> collection.push result
          collection

      .service name
]
