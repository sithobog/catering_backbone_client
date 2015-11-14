define [
  'jquery'
  'underscore'
  'jquery_ui'
  'backbone'
  'templates'

  'collections/daily_rations',
  'views/categories_collection'

  'helpers/days'
], ($, _, ui, Backbone, JST, DailyRationCollection, CategoriesCollectionView, DaysHelper) ->
  class DailyRationCollectionView extends Backbone.View
    template: JST['app/scripts/templates/daily_rations_collection.hbs']

    events: {
      "click input[type=checkbox]": "bindInputs"
    }  

    initialize: (collection) ->
      this.collection = collection
      this.collection.bind('sync', this.render, this)

      @categories_collection_view = new CategoriesCollectionView(categories: collection["models"][0]["nested_collection"])

    #trigger disabled attribute of number input by checkbox
    bindInputs: (event) ->
      checkbox = event.target
      number_input = $(checkbox).closest('.dish_body').find('input[type=number]')
      if ($(checkbox)).is(":checked")
        number_input.removeAttr('disabled')
      else
        number_input.prop('disabled', true)

      Backbone.pubSub.trigger('add_dish', event)



    #unbind collection events
    onClose: ->
      this.collection.unbind("change", this.render)

    render: () ->
      @$el.html @template(days: @collection.toJSON())

      #turn on jquery ui tabs widget
      $("#tabs").tabs()
