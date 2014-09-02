template = Handlebars.templates['tasks/task_sticker']


class TaskStickerView extends Backbone.View
  tagName: 'li'

  events:
    'click .task-sticker-title a': 'taskNameClicked'
    'click .task-sticker-move-left': 'moveLeftClicked'
    'click .task-sticker-move-right': 'moveRightClicked'

  taskNameClicked: (e) ->
    @editTask @model
    e.preventDefault()
    e.stopPropagation()

  moveLeftClicked: (e) ->
    @moveLeft @model
    e.preventDefault()
    e.stopPropagation()

  moveRightClicked: (e) ->
    @moveRight @model
    e.preventDefault()
    e.stopPropagation()


  editTask: (task = @model) ->
    @boardView.taskPopupView.render(task).done (operation) =>
      if operation is 'deleted'
        @remove()
      else if operation is 'moved'
        @boardView.refresh()
      else
        @refresh()

  moveLeft: (task = @model) ->
    promise = task.moveLeft()
    if promise?
      @$container = @$container.parent().prev().children('ul')
      @render()

  moveRight: (task = @model) ->
    promise = task.moveRight()
    if promise?
      @$container = @$container.parent().next().children('ul')
      @render()


  compose: (task = @model) ->
    task.toJSON()

  refresh: ->
    @$el.html(template(@compose(@model))).appendTo(@$container)
    this

  render: (task) ->
    if task? then @model = task else task = @model
    @refresh()
    this

  initialize: (options) ->
    @$container = if _.isString(options.container)
      @$(options.container)
    else
      options.container
    @boardView = options.boardView


window.TaskStickerView = TaskStickerView
