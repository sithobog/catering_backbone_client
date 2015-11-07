define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'models/sprint',
  #'collections/sprints'

  'views/panel'
], ($, _, Backbone, JST, SprintModel, PanelView) ->
  class SprintView extends Backbone.View
    template: JST['app/scripts/templates/sprint.hbs']

    el: '#container'

    panel: new PanelView()

    events: {}

    initialize: (options) ->
      @sprint_id = options.sprint_id
      @collection = options.collection
      @collection.bind("sync", this.render, this)
      console.log("From sprint view")
      console.log(@collection)


    render: () ->
      if @collection.size() != 0
        _sprint = @collection.get(@sprint_id)
        @$el.html @template(sprint: _sprint.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
