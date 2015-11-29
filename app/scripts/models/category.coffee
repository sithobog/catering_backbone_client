define [
  'underscore'
  'backbone'
  'models/dish'
  'collections/dish_collection'
], (_, Backbone, DishModel, DishCollection) ->
  'use strict';

  class CategoryModel extends Backbone.Model

    initialize: (options)->
      @title = options.title
      dish_collection = options.collection
      models = new DishCollection()
      _.each(dish_collection, (dish)->
        models.add(new DishModel(id: dish["id"],title: dish["title"], description: dish["description"], price: dish["price"], children: dish["children"], type: dish["type"]))
      )

      @nested_collection = models




