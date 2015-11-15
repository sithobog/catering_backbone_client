define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'collections/category_collection'

  'views/dish_collection'
], ($, _, Backbone, JST, CategoriesCollection, DishCollectionView) ->
  class CategoriesCollectionView extends Backbone.View
    template: JST['app/scripts/templates/categories_collection.hbs']

    events: {}

    initialize: (options) ->
      @init_collection = options.collection
      @day_number = options.day_number
      #grab category collection
      @category_collection = options.collection["models"][@day_number]["nested_collection"]


    renderDishes: ->
      this_collection = @init_collection
      this_day = @day_number
      i=0
      array= []
      #grab ids of categories
      ids = _.pluck(@category_collection["models"], "id")
      _.each(@category_collection,->
        #create view for collection
        view = new DishCollectionView(collection: this_collection["models"][this_day]["nested_collection"]["models"][i]["nested_collection"], day: this_day)
        #place view to unique div
        view.$el = @$('.dishes_loop-'+this_day+".dish-categories-"+ids[i])
        view.render()
        view.delegateEvents()
        i=i+1
      )

    render: () ->
      @$el.html @template(categories: @category_collection.toJSON(), day_number: @day_number)

      this.renderDishes()


