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

    initialize: () ->

    render: () ->
      @$el.html @template()

