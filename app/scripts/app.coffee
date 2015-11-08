define [
  'jquery',
  'underscore',
  'backbone',
  'router',

  'models/session',
  'models/sprint',
  'collections/sprints'
  'collections/daily_rations'

  'views/contacts',
  'views/login',
  'views/sprints_collection',
  'views/daily_rations_collection'
  'views/sprint'
], ($, _, Backbone, Router, Session, Sprint, SprintsCollection, DailyRationCollection, ContactsView, LoginView, SprintsCollectionView, DailyRationView, SprintView) ->
  class Application
    @defaults = 
      api_endpoint: "http://127.0.0.1:3000/api/v1"
    constructor: (options = {}) ->
      @router = null
      @options = $.extend(Application.defaults, options)

    initialize: () ->
      this._initConfiguration()
      this._initRoutes()
      this._initEvents()
    
    _initConfiguration: ->
      self = this

      $.ajaxPrefilter \
        (options, originalOptions, jqXHR) ->
          options.url = "#{self.options.api_endpoint}#{options.url}"
          no


    _initRoutes: ->
      @router = new Router()

      @router.on 'route:login', (page) ->
        _view = new LoginView()
        _view.render()

      @router.on 'route:contacts', (page) ->
        _view = new ContactsView()
        _view.render()

      @router.on 'route:sprints', (page) ->
        sprints = new SprintsCollection()
        _view = new SprintsCollectionView(collection: sprints)
        _view.render()

      @router.on 'route:sprint', (sprint_id) ->

        _collection1 = new SprintsCollection()
        _view = new SprintView(sprint_id: sprint_id, collection: _collection1)
        _view.render()

      @router.on 'route:rations', (page) ->
        _collection2 = new DailyRationCollection()
        _view = new DailyRationView(collection: _collection2)
        _view.render()

      Backbone.history.start()

    _initEvents: ->
      self = this

      Session.on 'change:auth', (session) ->
        self.checkAuth()
      # Check if user already logined
      Session.getAuth()

    checkAuth: ->
      if Session.get('auth') is true
        @router.navigate("sprints", {trigger: true})
      else
        @router.navigate("contacts", {trigger: true})

  return new Application()
