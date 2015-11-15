define [
  'underscore'
  'backbone'
  'models/dish'
  'models/category'
  'collections/category_collection'
], (_, Backbone, DishModel, CategoryModel, CategoryCollection) ->
  'use strict';

  class DailyRationModel extends Backbone.Model

    initialize: ->
      self = this
      #console.log("DAILY RATION MODEL IS CREATED")

      models = new CategoryCollection()
      _.each(self.attributes["categories"], (category)->
        models.add(new CategoryModel(id: category["id"], title: category["title"], collection: category["dishes"]))
      )
      @nested_collection = models
