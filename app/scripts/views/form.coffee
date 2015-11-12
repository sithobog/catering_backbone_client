define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'views/sprint'
  'views/daily_rations_collection'
  'views/panel'

  'collections/daily_rations'

], ($, _, Backbone, JST, SprintView, DailyRationsCollectionView, PanelView, DailyRationsCollection) ->
  class DailyRationsFormView extends Backbone.View
    template: JST['app/scripts/templates/form.hbs']

    el: '#container'

    panel: new PanelView()

    events: {
      "click button.btn-primary": "submit"
    }

    initialize: (sprint, collection, api_endpoint) ->
      @sprint = sprint
      @daily_rations_collection = collection
      @api_endpoint = api_endpoint
      console.log("BEFORE view create")
      console.log(@sprint)
      @sprintView = new SprintView(sprint: @sprint)
      @dailyRationView = new DailyRationsCollectionView(@daily_rations_collection)

    render: ->
      @$el.html @template()

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()

      # Render sprint date
      @sprintView.$el = @$('#sprintContainer')
      @sprintView.render()
      @sprintView.delegateEvents()

      # Render form tabs
      @dailyRationView.$el = @$('#dailyRations')
      @dailyRationView.render()
      @dailyRationView.delegateEvents()

    submit:(event) ->
      event.preventDefault()
      
      #order = new Order()

      creds = $("#order_form").serialize()
      collection = new DailyRationsCollection()
      collection.save(creds)
