define [
  'jquery'
  'underscore'
  'jquery_ui'
  'backbone'
  'templates'

  'collections/daily_rations',

  'views/panel'
  'helpers/days'
], ($, _, ui, Backbone, JST, DailyRationCollection, PanelView, DaysHelper) ->
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
      $("#tabs").tabs()

      $('input[type=checkbox]').click(() ->
        id = $(this).attr('id')
        input_el = $('#' + id + '-inp')
        toggled = input_el.attr('disabled')
        toggled = !toggled
        input_el.prop('disabled', toggled)
      )

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
