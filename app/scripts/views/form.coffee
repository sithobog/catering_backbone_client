define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'views/sprint'
  'views/day_collection'
  'views/panel'
  'views/pre_order'
  'views/daily_ration'

  'collections/daily_ration_collection'

], ($, _, Backbone, JST, SprintView, DayCollectionView, PanelView, PreOrderView, DailyRationView, DailyRationCollection) ->
  class DailyRationsFormView extends Backbone.View
    template: JST['app/scripts/templates/form.hbs']

    el: '#container'

    panel: new PanelView()

    events: {
      "click button.send_order": "submit"
      "click .ui-tabs-anchor": "listAccordion"
    }

    initialize: (sprint, collection, api_endpoint) ->
      @sprint = sprint
      @day_collection = collection
      @api_endpoint = api_endpoint
      @sprintView = new SprintView(sprint: @sprint)
      @daysView = new DayCollectionView(collection: @day_collection, sprint: @sprint)
      @preOrderView = new PreOrderView(collection: @day_collection, sprint: @sprint)

      Backbone.pubSub.on('rations-saved', this.callRoute, this)

    listAccordion: (event) ->
      link_in_tab = $(event.target)
      day = link_in_tab.data("day-in-tab")
      $(".accordion" ).accordion( "option", "active", day )

      Backbone.pubSub.trigger('change-tab')

    render: ->
      @$el.html @template(days: @day_collection.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()

      # Render sprint date
      @sprintView.$el = @$('#sprintContainer')
      @sprintView.render()
      @sprintView.delegateEvents()

      # Render form tabs
      @daysView.$el = @$('#daysCollection')
      @daysView.render()
      @daysView.delegateEvents()

      # Render pre_order field
      @preOrderView.$el = @$('#pre-order')
      @preOrderView.render()
      @preOrderView.delegateEvents()

    submit:(event) ->
      event.preventDefault()
      
      creds = $("#order_form").serializeArray()

      collection = new DailyRationCollection()

      collection.fillCollection(creds)

    callRoute: ->
      Backbone.pubSub.trigger('render_order',{sprint: @sprint})

