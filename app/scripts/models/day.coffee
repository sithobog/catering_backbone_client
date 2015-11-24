define [
  'underscore'
  'backbone'
  'models/dish'
  'models/category'
  'collections/category_collection'
], (_, Backbone, DishModel, CategoryModel, CategoryCollection) ->
  'use strict';

  class DayModel extends Backbone.Model

    initialize: ->
      self = this

      models = new CategoryCollection()
      _.each(self.attributes["categories"], (category)->
        models.add(new CategoryModel(id: category["id"], title: category["title"], collection: category["dishes"]))
      )
      @nested_collection = models
