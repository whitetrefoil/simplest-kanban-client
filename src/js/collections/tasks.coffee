class Tasks extends BaseCollection
  model: Task

  idAttribute: '_id'

  url: '/tasks'

  comparator: 'name'

window.Tasks = Tasks
