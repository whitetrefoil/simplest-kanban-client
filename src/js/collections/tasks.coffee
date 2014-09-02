define [
  'lodash'
  'collections/base'
  'models/task'
], (
  _
  BaseCollection
  Task
) ->

  class Tasks extends BaseCollection
    model: Task

    idAttribute: '_id'

    url: '/tasks'

    comparator: 'name'

  return Tasks