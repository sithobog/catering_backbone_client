define [
  'underscore'
  'backbone'
  'models/dish'
], (_, Backbone, DishModel) ->

  class DishCollection extends Backbone.Collection
    model: DishModel
###
    initialize: (options) ->

    	dishes = options.dishes

    	all_dishes = _.each(dishes["dishes"], (dish)->
    		new DishModel(test: "TEST LALAL ", id: dish["id"], title: dish["title"], price: dish["price"], description: dish["description"])
    	)
###

