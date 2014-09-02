requirejs.config
  baseUrl: 'js'
  paths:
    lib: '../lib'
    config: '../data/config'
    data: 'utils/data'
    jquery: '../lib/jquery/jquery'
    hbs: '../lib/require-handlebars-plugin/hbs'
    backbone: '../lib/backbone/backbone'
    bootstrap: '../lib/bootstrap-sass-official/js/bootstrap'
  shim:
    bootstrap: [ 'jquery' ]
  packages: [
    name: 'lodash'
    location: '../lib/lodash-amd/modern'
  ,
    name: 'underscore',
    location: '../lib/lodash-amd/underscore'
  ]


requirejs [
  'jquery'
  'config'
  'data'
  'backbone'
  'routers/index'
  'collections/tasks'
], (
  $
  Config
  Data
  Backbone
  IndexRouter
  Tasks
) ->

  Data.tasks = new Tasks()

  new IndexRouter()

  Backbone.history.start()
