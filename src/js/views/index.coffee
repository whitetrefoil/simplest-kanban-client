define [
  'lodash'
  'data'
  'backbone'
  'views/task_sticker'
  'views/task_popup'
  'hbs!tpls/index'
], (
  _
  Data
  Backbone
  TaskStickerView
  TaskPopupView
  Template
) ->

  class IndexPageView extends Backbone.View
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

      Data.tasks.forEach (task) ->
        column = (tasks[task.get('status')] ||= [])
        column.push(task)

      tasks


    refresh: ->
      $.when(Data.tasks.fetch()).done =>
        @renderData()

    renderData: ->
      statuses = @compose()
      @taskViews ||= []
      _.forEach @taskViews, (taskView) -> taskView.remove()
      _.forEach statuses, (status, statusCode) =>
        $container = $("##{statusCode}-col > ul")
        _.forEach status, (task) =>
          @taskViews.push new TaskStickerView({
            model: task
            container: $container
            boardView: this
          }).render()


    renderStatic: ->
      @$el.html Template()
      @taskPopupView ||= new TaskPopupView()

    render: ->
      @renderStatic()
      @refresh()
