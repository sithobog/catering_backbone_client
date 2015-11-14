define [
  'underscore'
  'backbone'
  'models/category'
], (_, Backbone, CategoryModel) ->

  class CategoryCollection extends Backbone.Collection
    model: CategoryModel
