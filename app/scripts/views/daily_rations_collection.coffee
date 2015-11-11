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

    events: {
      "click input[type=checkbox]": "bindInputs"
    }  

    initialize: (options) ->
      @sprint_id = options.sprint_id
      this.collection.bind('sync', this.render, this)

    #trigger disabled attribute of number input by checkbox
    bindInputs: (event) ->
      checkbox = event.target
      number_input = $(checkbox).closest('.dish_body').find('input[type=number]')
      if ($(checkbox)).is(":checked")
        number_input.removeAttr('disabled')
      else
        number_input.prop('disabled', true)

    #unbind collection events
    onClose: ->
      this.collection.unbind("change", this.render)

    render: () ->
      @$el.html @template(sprint_id: @sprint_id, days: @collection.toJSON())
      #turn on jquery ui tabs widget
      $("#tabs").tabs()

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()
