define [
  'underscore'
  'backbone'
  'models/dish'
], (_, Backbone, DishModel) ->

  class DishCollection extends Backbone.Collection
    model: DishModel
