template = Handlebars.templates['tasks/task_popup']


class SK.TaskPopupView extends Backbone.View
  id: 'taskPopup'
  tagName: 'div'
  className: 'popup'
  attributes:
    tabindex: -1

  events:
    'submit form': 'formSubmitted'
    'click .popup-footer .delete-button': 'deleteButtonClicked'
    'click .popup-footer .cancel-button': 'cancelButtonClicked'
    'click .popup-delete-prompt .delete-button': 'confirmDeleteButtonClicked'
    'click .popup-delete-prompt .cancel-button': 'cancelDeleteButtonClicked'

  formSubmitted: (e) ->
    form = e.currentTarget.elements
    @saveTask
      name: form.name.value
      assignee: form.assignee.value
      status: form.status.value
    e.preventDefault()
    e.stopPropagation()

  deleteButtonClicked: (e) ->
    @toggleDeletePrompt(true)
    e.preventDefault()
    e.stopPropagation()

  cancelButtonClicked: (e) ->
    @remove()
    e.preventDefault()
    e.stopPropagation()

  confirmDeleteButtonClicked: (e) ->
    @deleteTask()
    e.preventDefault()
    e.stopPropagation()

  cancelDeleteButtonClicked: (e) ->
    @toggleDeletePrompt(false)
    e.preventDefault()
    e.stopPropagation()


  toggleDeletePrompt: (toShow = true) ->
    @$('.popup-footer').toggle(!toShow)
    @$('.popup-delete-prompt').toggle(toShow)

  createNewTask: ->
    task = new SK.Data.tasks.model()
    task.status = 'op'
    SK.Data.tasks.add(task)
    task

  saveTask: (taskAttributes, task = @model) ->
    task.set taskAttributes
    isMoved = task.hasChanged('status')
    task.save null,
      wait: true
      success: =>
        @deferred.resolve if isMoved then 'moved' else 'saved'
        @remove()

  deleteTask: (task = @model) ->
    task.destroy
      wait: true
      success: =>
        @deferred.resolve('deleted')
        @remove()


  compose: (task = @model) ->
    json = task.toJSON()
    data =
      title: 'New Task'
      formId: 'newTaskForm'
      task: json
      isNew: task.isNew()
      selected:
        op: false
        ip: false
        sh: false
        dev: false
    data.selected[json.status] = true
    data

  render: (task) ->
    if !task?
      @model = @createNewTask()
    else if _.isString(task)
      @model = SK.Data.tasks.get(task)
    else
      @model = task
    @$el.html(template(@compose(@model))).appendTo($('body')).modal
      backdrop: 'static'
    @delegateEvents()
    @deferred = $.Deferred()
    @deferred.promise()

  remove: ->
    $el = @$el
    @stopListening()
    @off()
    $el.on('hidden.bs.modal', -> $el.remove()).modal 'hide'
    @deferred.reject() if @deferred.state() is 'pending'
