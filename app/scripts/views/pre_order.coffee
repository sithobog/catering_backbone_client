define [
  'jquery'
  'underscore'
  'jquery_ui'
  'backbone'
  'templates'

], ($, _, ui, Backbone, JST, SprintModel) ->
  class SprintView extends Backbone.View
    template: JST['app/scripts/templates/pre_order.hbs']

    events: {
      "click input[type=checkbox]": "bindInputs"
      "click button.next,button.previous": "changeDay"
    }

    initialize: (options) ->
      @collection = options.collection

      #listen to events
      Backbone.pubSub.on('change-tab', this.checkActive)
      Backbone.pubSub.on('refresh-numbers', this.addNumbers)

    checkActive: ->
      active = $("#tabs").tabs("option","active")
      if active == 6
        $("button.next").prop("disabled", true)
      else
        $("button.next").removeAttr("disabled")

      if active == 0
        $("button.previous").prop("disabled", true)
      else
        $("button.previous").removeAttr("disabled")

    addNumbers: ->
      console.log("ADD NUMBERS IS TRIGGERED!")
      selected_tab_selector = $(".day_body[aria-hidden='false']")
      current_day = selected_tab_selector.find(".current_day").text()
      active_day_selector = $(".day_order."+current_day)

      numbers = active_day_selector.parent().find(".number_in_order")
      i=1
      _.each(numbers, (number)->
        $(number).text(i+". ")
        i= i+1
      )

    changeDay: ->
      event.preventDefault()
      change_day = $(event.target).data("change-day")
      active = $("#tabs").tabs("option", "active")
      $("#tabs").tabs("option","active",active+change_day)
      # synchronize tabs and accordion
      $(".accordion" ).accordion( "option", "active", active+change_day )
      this.checkActive()

    render: () ->
      categories_id = _.pluck(@collection["models"][0]["attributes"]["categories"], 'id')
      @$el.html @template(days: @collection.toJSON(), categories_id: categories_id)

      #turn on jquery ui accordion widget
      $(".accordion").accordion({
        heightStyle: "content",
        create: (event, ui)->
          Backbone.pubSub.trigger('change-tab')
      })
