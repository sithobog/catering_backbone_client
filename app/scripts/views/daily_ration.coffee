define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'views/panel'

  'collections/order_collection'
  'models/order'

  'helpers/days'
], ($, _, Backbone, JST, PanelView, OrderCollection, OrderModel, DaysHelper) ->
  class DailyRationView extends Backbone.View
    template: JST['app/scripts/templates/daily_ration.hbs']

    el: '#container'

    panel: new PanelView()

    events: {}

    initialize: (options) ->
      self = this
      @sprint = options.sprint
      if !options.collection
        order_collection = new OrderCollection(sprint: @sprint)

        order_collection.fetch().then(()->
          self.order_collection = order_collection
          Backbone.pubSub.trigger('order-ready')
        )
      else
        @order_collection = options.collection


    render: () ->
      @$el.html @template(sprint: @sprint, day: @order_collection.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
