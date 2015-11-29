define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'models/sprint',
  #'collections/sprints'

  'views/panel'
  'helpers/date_helper'
], ($, _, Backbone, JST, SprintModel, PanelView) ->
  class SprintView extends Backbone.View
    template: JST['app/scripts/templates/sprint.hbs']

    el: '#container'

    panel: new PanelView()

    events: {}

    initialize: (options) ->
      @sprint = options.sprint
      this.bind("sync", this.render, this)

    render: () ->
      @$el.html @template(sprint: @sprint.toJSON())

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
