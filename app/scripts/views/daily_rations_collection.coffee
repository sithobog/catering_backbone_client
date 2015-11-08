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

    initialize: (options) ->
      @sprint_id = options.sprint_id
      this.collection.bind('sync', this.render, this)

    render: () ->
      @$el.html @template(sprint_id: @sprint_id, days: @collection.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
