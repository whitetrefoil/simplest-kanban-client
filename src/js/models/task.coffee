class Task extends BaseModel
  idAttribute: '_id'

  urlRoot: '/tasks'

  statuses: [
    'op', 'ip', 'sh', 'dev'
  ]

  validate: (attrs) ->
    return 'missing name' if _.isEmpty attrs.name
    return 'missing assignee' if _.isEmpty attrs.assignee
    return 'invalid status' unless _.contains(@statuses, @get('status'))


  move: (step) ->
    newIndex = @statuses.indexOf(@get('status')) + step
    if newIndex <= 0 or newIndex >= @statuses.length
      promise = null
    else
      @set('status', @statuses[newIndex])
      promise = @save({ wait: true })
    promise

  moveLeft: ->
    @move(-1)

  moveRight: ->
    @move(1)


window.Task = Task
