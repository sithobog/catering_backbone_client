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
      "calculate" : "calculate_price"
    }

    initialize: (options) ->
      @collection = options.collection

    add_dish: (event) ->

      checkbox = event.target

      selected_tab_selector = $(".day_body[aria-hidden='false']")

      current_day = selected_tab_selector.find(".current_day").text()
        
      active_day_selector = $(".day_order."+current_day)

      price = $(checkbox).closest(".dish_body").find("span.price").text()
      dish_title = $(checkbox).closest(".dish_body").find("span.dish_title").text()
      active_day_selector.prepend("<div class='item_in_order '>"+"<span class='title_for_dish'>"+dish_title+"</span>"+
                        " X "+
                        "<span class='quantity_in_order'></span>"+
                        "<span class='currency pull-right'>UAH</span>"+
                        "<span class='price_for_dish pull-right'>"+price+" </span></div>")

      console.log("Here is ....")
      console.log(active_day_selector.find(".price_for_dish").length)

      Backbone.pubSub.trigger('calculate', event)


    calculate_price: ->

      prices = []
      _.each(@collection["models"], (element)->
        prices.push(element["attributes"]["max_total"])
      )
      console.log(prices)

      week_days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

      ready_hash = _.object(week_days, prices)
      console.log(ready_hash)

      console.log("monday_price is")
      console.log(ready_hash["monday"])

      selected_tab_selector = $(".day_body[aria-hidden='false']")
      current_day = selected_tab_selector.find(".current_day").text()
      active_day_selector = $(".day_order."+current_day)

      price_for_day = active_day_selector.find(".price_for_dish").text()
      console.log("Price is")
      console.log(price_for_day)
      
      array = price_for_day.split(' ')

      #remove zero at the end of array
      array.pop()

      #convert string to number
      array = _.map(array, (n)->
        Number(n)
      )
      console.log("Parsed array")
      console.log(array)

      sum = _.reduce(array, (memo,num)->
        memo+num
      )

      console.log("Total sum is ")
      console.log(sum)

      checkbox = event.target
      console.log("HERE IS A EVENT TARGET")
      console.log(checkbox)

      input_number_selector = $(checkbox).closest(".dish_body").find("input[type='number']")
      quantity_selector = active_day_selector.find(".quantity_in_order")

      quantity_selector.text(input_number_selector.val())

      #listener 
      input_number_selector.keyup(->
        quantity_selector.text(input_number_selector.val())
      )

      quantity = input_number_selector.val()

      console.log("quantity is .........")
      console.log(quantity)

      remaining_balance_selector = active_day_selector.find(".remaining_balance")
      order_total_selector = active_day_selector.find(".order_total")
      order_total_selector.text(sum)
      balance = ready_hash[current_day]-sum

      remaining_balance_selector.text(balance)


    render: () ->
      @$el.html @template(days: @collection.toJSON())

      Backbone.pubSub.on('add_dish', this.add_dish, this)
      Backbone.pubSub.on('calculate', this.calculate_price, this)

      #turn on jquery ui accordion widget
      $(".accordion").accordion({heightStyle: "content"})
