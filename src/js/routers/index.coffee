SK.Data.tasks ||= new SK.Tasks()

pageView = new SK.IndexPageView()

class SK.IndexRouter extends SK.BaseRouter

  routes:
    '': 'index'

  # routers

  index: ->
    pageView.render()
