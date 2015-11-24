define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'views/sprint'
  'views/day_collection'
  'views/panel'
  'views/pre_order'

  'collections/daily_ration_collection'

], ($, _, Backbone, JST, SprintView, DayCollectionView, PanelView, PreOrderView, DailyRationCollection) ->
  class DailyRationsFormView extends Backbone.View
    template: JST['app/scripts/templates/form.hbs']

    el: '#container'

    panel: new PanelView()

    events: {
      "click button.btn-primary": "submit"
      "click .ui-tabs-anchor": "listAccordion"
    }

    initialize: (sprint, collection, api_endpoint) ->
      @sprint = sprint
      @day_collection = collection
      @api_endpoint = api_endpoint
      @sprintView = new SprintView(sprint: @sprint)
      @daysView = new DayCollectionView(@day_collection)
      @preOrderView = new PreOrderView(collection: @day_collection)


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
      
      creds = $("#order_form").serialize()
      collection = new DailyRationCollection()
      collection.save(creds)
