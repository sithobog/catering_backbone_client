define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  'router'

  'views/sprint'
  'views/day_collection'
  'views/panel'
  'views/pre_order'
  'views/daily_ration'

  'collections/daily_ration_collection'

], ($, _, Backbone, JST, Router, SprintView, DayCollectionView, PanelView, PreOrderView, DailyRationView, DailyRationCollection) ->
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
      @router = new Router()

      Backbone.pubSub.on('order-ready', this.renderOrder, this)
      Backbone.pubSub.on('rations-saved', this.redirectToOrder, this)

      this_view = this
      this_sprint = @sprint
      @router.on 'route:order', (sprint_id) ->
        this_view.viewOrder = new DailyRationView(sprint: this_sprint)

    #this function is called then order collection is filled
    renderOrder: ->
      @viewOrder.render()

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

      #@render_collection = collection

    redirectToOrder: ->
      
      @router.navigate("order/"+@sprint.id, {trigger: true})



