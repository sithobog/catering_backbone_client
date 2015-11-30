define [
  'jquery',
  'underscore',
  'backbone',
  'router',

  'views/app'

  'models/session',
  'models/sprint',
  'collections/sprints'
  'collections/day_collection'
  'collections/order_collection'

  'views/contacts',
  'views/login',
  'views/sprints_collection',
  'views/day_collection'
  'views/sprint'
  'views/form'
  'views/daily_ration'
], ($, _, Backbone, Router, AppView, Session, Sprint, SprintsCollection, DayCollection, OrderCollection,
     ContactsView, LoginView, SprintsCollectionView, DayCollectionView, SprintView, FormView, DailyRationView) ->
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
        view = new LoginView()
        view.render()

      @router.on 'route:contacts', (page) ->
        view = new ContactsView()
        view.render()

      @router.on 'route:sprints', (page) ->
        sprints = new SprintsCollection()
        view = new SprintsCollectionView(collection: sprints)
        view.render()

      @router.on 'route:sprint_rations', (sprint_id) ->
        api_endpoint = Application.api_endpoint
        sprints_collection = new SprintsCollection()
        day_collection = new DayCollection()
        order_collection = {}
        sprint = {}
        sprints_collection.fetch().then(()->
          sprint = sprints_collection.get(sprint_id)
          order_collection = new OrderCollection(sprint: sprint)
        ).then(()->
          #grab collection from server, if collection is empty, render form to create order
          order_collection.fetch().then(()->
            if order_collection.length == 0
              day_collection.fetch().then(()->
                AppView.showView(new FormView(sprint,day_collection,api_endpoint))
              )
            else
              AppView.showView(new DailyRationView(sprint: sprint, collection: order_collection))
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
        #@router.navigate("sprints", {trigger: true})
      else
        #@router.navigate("contacts", {trigger: true})

  return new Application()
