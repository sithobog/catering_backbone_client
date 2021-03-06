define [
  'jquery'
  'underscore'
  'jquery_ui'
  'backbone'
  'templates'

  'collections/day_collection'
  'views/categories_collection'

  'helpers/days'
  'helpers/date_helper'
], ($, _, ui, Backbone, JST, DaysCollection, CategoriesCollectionView, DaysHelper, DateHelper) ->
  class DayCollectionView extends Backbone.View
    template: JST['app/scripts/templates/day_collection.hbs']

    events: {}

    initialize: (options) ->
      @collection = options.collection
      @sprint = options.sprint
      @collection.bind('sync', this.render, this)
      #create array of days_id
      days = []
      _.each(@collection["models"], (element)->
        days.push(element["attributes"]["id"])
      )
      @day_ids = days

    renderCategories: ->
      events_for_view = this.events
      this_collection = @collection
      this_day_ids = @day_ids
      i=0
      _.each(this_collection["models"],->
        view = new CategoriesCollectionView(collection: this_collection, day_number: i, day_id: this_day_ids[i])
        view.$el = @$('.categories-'+i)
        view.render()
        view.delegateEvents()
        i=i+1
      )

    #unbind collection events
    onClose: ->
      this.collection.unbind("change", this.render)

    render: () ->
      @$el.html @template(days: @collection.toJSON(), sprint: @sprint.toJSON())

      this.renderCategories()

      $("#tabs").tabs()
