define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'collections/dish_collection'

  'helpers/math'

], ($, _, Backbone, JST, DishCollection) ->
  class ItemCollectionView extends Backbone.View
    template: JST['app/scripts/templates/item.hbs']

    events: {}

    initialize: (options) ->
      @collection = options.collection
      this.listenTo(@collection,'change remove', this.render)

    render: () ->
      @$el.html(@template(items: @collection.toJSON()))

      #Backbone.pubSub.trigger('refresh-numbers')


