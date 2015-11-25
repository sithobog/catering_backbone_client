define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'views/panel'
], ($, _, Backbone, JST, PanelView) ->
  class DailyRationView extends Backbone.View
    template: JST['app/scripts/templates/daily_ration.hbs']

    el: '#container'

    panel: new PanelView()

    events: {}

    initialize: (options) ->
      @collection = options.collection
      @sprint = options.sprint
      console.log("COLLECTION BEFORE GROUP BY")
      console.log(@collection)

      @grouped_collection = @collection.groupBy((model)->
        model.get('day_id')
      )

      console.log("COLLECTION AFTER GROUP BY")
      console.log(@grouped_collection)
      #this.bind("sync", this.render, this)

    render: () ->
      @$el.html @template(sprint: @sprint, order_items: @collection.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
