define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'collections/category_collection'
], ($, _, Backbone, JST, CategoriesCollection) ->
  class DishCollectionView extends Backbone.View
    template: JST['app/scripts/templates/categories_collection.hbs']

    events: {}

    initialize: () ->

    render: () ->
      @$el.html @template()

