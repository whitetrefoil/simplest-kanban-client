define [
  'routers/base'
  'views/index'
], (
  BaseRouter
  IndexPageView
) ->
  pageView = new IndexPageView()

  class IndexRoute extends BaseRouter

    routes:
      '': 'index'

    # routers

    index: ->
      pageView.render()


  return IndexRoute