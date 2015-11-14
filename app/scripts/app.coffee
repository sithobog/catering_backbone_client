define [
  'jquery',
  'underscore',
  'backbone',
  'router',

  'views/app'

  'models/session',
  'models/sprint',
  'collections/sprints'
  'collections/daily_rations'

  'views/contacts',
  'views/login',
  'views/sprints_collection',
  'views/daily_rations_collection'
  'views/sprint'
  'views/form'
], ($, _, Backbone, Router, AppView, Session, Sprint, SprintsCollection, DailyRationCollection,
     ContactsView, LoginView, SprintsCollectionView, DailyRationView, SprintView, FormView) ->
  class Application

    #activate pub/sub events
    Backbone.pubSub = _.extend({}, Backbone.Events)

    #remove all events from view that was closed
    Backbone.View.prototype.close = ->
      this.undelegateEvents()
      if this.onClose
        this.onClose()

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
        _collection1.fetch().then(()->
          sprint = _collection1.get(sprint_id)
          console.log(sprint)
          _view = new SprintView(sprint: sprint)
          _view.render()
        )

      @router.on 'route:sprint_rations', (sprint_id) ->
        api_endpoint = Application.api_endpoint
        _sprints_collection = new SprintsCollection()
        _daily_rations_collection = new DailyRationCollection()
        
        _sprints_collection.fetch().then(()->
          sprint = _sprints_collection.get(sprint_id)
          _daily_rations_collection.fetch().then(()->
            AppView.showView(new FormView(sprint,_daily_rations_collection,api_endpoint))
          )
        )

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
