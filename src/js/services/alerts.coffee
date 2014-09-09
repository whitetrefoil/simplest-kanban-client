'use strict'

class AlertsService
  setAlertsScope: (@scope) ->

  closeAlert: (key) ->
    _.remove @scope, {key: key}

  addAlert: (msg, type, key = Math.random().toString()) ->
    @closeAlert(key)
    @scope.push
      type: type
      msg: msg
      key: key
      close: => @closeAlert(key)

angular.module 'simplestKanban'
.service 'AlertsService', [AlertsService]
