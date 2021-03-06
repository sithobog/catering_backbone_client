define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'collections/sprints',

  'views/panel'

  'helpers/date_helper'
], ($, _, Backbone, JST, SprintsCollection, PanelView) ->
  class SprintsCollectionView extends Backbone.View
    template: JST['app/scripts/templates/sprints_collection.hbs']
    tagName: "form"
    el: '#container'

    panel: new PanelView()

    events: {}

    initialize: () ->
      this.collection.bind('sync', this.render, this);

    render: () ->
      @$el.html @template(sprints: @collection.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
