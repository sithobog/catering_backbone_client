define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  'moment'

  'views/panel'

  'collections/order_collection'
  'models/order'

  'helpers/days'
  'helpers/date_helper'
  'helpers/generate_date'
], ($, _, Backbone, JST, Moment, PanelView, OrderCollection, OrderModel, DaysHelper, DateHelper, GenerateDate) ->
  class DailyRationView extends Backbone.View
    template: JST['app/scripts/templates/daily_ration.hbs']

    el: '#container'

    panel: new PanelView()

    events: {"click .business_lunch" : "triggerBusinessLunch"}

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

    triggerBusinessLunch: ->
      business_lunch = $(event.target).closest(".order_body")
      children = business_lunch.find(".children")
      children.slideToggle("slow")

    findToday: ->
      f = "DD_MM_YY"
      today = Moment(new Date()).format(f)

      for i in [0...7]
        date_to_compare = Moment(new Date(@sprint.toJSON().started_at)).add(i,"days").format(f)
        if today == date_to_compare
          $("."+today).addClass("today")

    render: () ->
      @$el.html @template(sprint: @sprint.toJSON(), day: @order_collection.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()

      this.findToday()
