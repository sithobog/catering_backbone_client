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
      @collection = collection
      @collection.bind('sync', this.render, this)

    #trigger disabled attribute of number input by checkbox
    bindInputs: (event) ->
      checkbox = event.target
      number_input = $(checkbox).closest('.dish_body').find('input[type=number]')
      if ($(checkbox)).is(":checked")
        number_input.removeAttr('disabled')
      else
        number_input.prop('disabled', true)

      Backbone.pubSub.trigger('add_dish', event)


    renderCategories: ->
      this_collection = @collection
      i=0
      _.each(this_collection["models"],->
        view = new CategoriesCollectionView(collection: this_collection, day_number: i)
        view.$el = @$('.categories-'+i)
        view.render()
        view.delegateEvents()
        i=i+1
      )



    #unbind collection events
    onClose: ->
      this.collection.unbind("change", this.render)

    render: () ->
      @$el.html @template(days: @collection.toJSON())

      this.renderCategories()

      $("#tabs").tabs()
