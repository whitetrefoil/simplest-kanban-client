template = Handlebars.templates.index

class SK.IndexPageView extends Backbone.View
  el: '#page'

  events:
    'click #main-navbar .add-button': 'newTaskButtonClicked'
    'click #main-navbar .refresh-button': 'refreshButtonClicked'

  newTaskButtonClicked: ->
    @newTask()

  refreshButtonClicked: ->
    @refresh()

  newTask: ->
    @taskPopupView.render().done =>
      @refresh()

  editTask: (task) ->
    @taskPopupView.render(task).done =>
      @refresh()


  compose: ->
    tasks =
      op: []
      ip: []
      sh: []
      dev: []

    SK.Data.tasks.forEach (task) ->
      column = (tasks[task.get('status')] ||= [])
      column.push(task)

    tasks


  refresh: ->
    $.when(SK.Data.tasks.fetch()).done =>
      @renderData()

  renderData: ->
    statuses = @compose()
    @taskViews ||= []
    _.forEach @taskViews, (taskView) -> taskView.remove()
    _.forEach statuses, (status, statusCode) =>
      $container = $("##{statusCode}-col > ul")
      _.forEach status, (task) =>
        @taskViews.push new SK.TaskStickerView({
          model: task
          container: $container
          boardView: this
        }).render()


  renderStatic: ->
    @$el.html template()
    @taskPopupView ||= new SK.TaskPopupView()

  render: ->
    @renderStatic()
    @refresh()
