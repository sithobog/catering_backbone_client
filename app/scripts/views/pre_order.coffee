define [
  'jquery'
  'underscore'
  'jquery_ui'
  'backbone'
  'templates'

], ($, _, ui, Backbone, JST, SprintModel) ->
  class SprintView extends Backbone.View
    template: JST['app/scripts/templates/pre_order.hbs']

    events: {
      "click input[type=checkbox]": "bindInputs"
    }

    initialize: (options) ->
      @collection = options.collection

    render: () ->
      categories_id = _.pluck(@collection["models"][0]["attributes"]["categories"], 'id')
      @$el.html @template(days: @collection.toJSON(), categories_id: categories_id)

      #turn on jquery ui accordion widget
      $(".accordion").accordion({heightStyle: "content"})
