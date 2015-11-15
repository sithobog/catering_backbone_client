define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'collections/dish_collection'
], ($, _, Backbone, JST, DishCollection) ->
  class DishCollectionView extends Backbone.View
    template: JST['app/scripts/templates/dish_collection.hbs']

    events: {}

    initialize: (options) ->
      @collection = options.collection
      @day = options.day

    render: () ->
      @$el.html @template(dishes: @collection.toJSON(), day: @day)

