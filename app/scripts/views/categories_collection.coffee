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
      @day_id = options.day_id
      #grab category collection
      @category_collection = options.collection["models"][@day_number]["nested_collection"]

      #create array of prices
      limit_array = []
      _.each(@collection["models"], (element)->
        limit_array.push(element["attributes"]["max_total"])
      )
      @limit_balance = limit_array




    renderDishes: ->
      this_collection = @init_collection
      this_day = @day_number
      i=0
      array= []
      #grab ids of categories
      @category_ids = _.pluck(@category_collection["models"], "id")
      this_category_ids = @category_ids
      this_day_id = @day_id
      this_prices = @limit_balance
      _.each(@category_collection,->
        #create view for collection
        view = new DishCollectionView(day_id: this_day_id,limit_balance: this_prices, collection: this_collection["models"][this_day]["nested_collection"]["models"][i]["nested_collection"], day: this_day, category_id: this_category_ids[i])
        #place view to unique div
        view.$el = @$('.dishes_loop-'+this_day+".dish-categories-"+this_category_ids[i])
        view.render()
        view.delegateEvents()
        i=i+1
      )

    render: () ->
      @$el.html @template(categories: @category_collection.toJSON(), day_number: @day_number)

      this.renderDishes()


