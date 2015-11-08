define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'collections/daily_rations',

  'views/panel'
], ($, _, Backbone, JST, DailyRationCollection, PanelView) ->
  class SprintsCollectionView extends Backbone.View
    template: JST['app/scripts/templates/daily_rations_collection.hbs']

    el: '#container'

    panel: new PanelView()

    events: {}

    initialize: () ->
      this.collection.bind('sync', this.render, this);

    render: () ->
      @$el.html @template(days: @collection.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
