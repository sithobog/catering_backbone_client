define [
  'underscore'
  'backbone'
  'models/item'
], (_, Backbone, ItemModel) ->

  class CategoryCollection extends Backbone.Collection
    model: ItemModel
