pageView = new IndexPageView()

class IndexRouter extends BaseRouter

  routes:
    '': 'index'

  # routers

  index: ->
    pageView.render()


window.IndexRouter = IndexRouter
