define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'collections/dish_collection'
  'views/item'
], ($, _, Backbone, JST, DishCollection, ItemView) ->
  class DishCollectionView extends Backbone.View
    template: JST['app/scripts/templates/dish_collection.hbs']

    events: {
      "click input[type=checkbox]": "bindInputs"
      "change input[type=number]": "updateQuantity"
      "keyup input[type=number]": "updateQuantity"
    }

    initialize: (options) ->
      @collection = options.collection
      @day = options.day
      @day_id = options.day_id
      @category_id = options.category_id
      @limit_balance = options.limit_balance
      @dish_for_render = new DishCollection()
      @week_days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

    bindInputs: (event) ->

      checkbox = event.target
      number_input = $(checkbox).closest('.dish_body').find('input[type=number]')
      if ($(checkbox)).is(":checked")
        number_input.removeAttr('disabled')
        this.addItem(event)
      else
        number_input.prop('disabled', true)
        this.removeItem(event)

      this.calculatePrice()

    updateQuantity: (event) ->
      initiator = event.target
      dish_body = $(initiator).closest('.dish_body')
      dish_id = +dish_body.data("dish-id")
      input_number_selector = dish_body.find("input[type='number']")
      quantity = input_number_selector.val()
      model = @collection.get(dish_id)
      model.set(quantity: quantity)

      # re-calculate price
      this.calculatePrice()


    filterCollection: ->

      #fill DishCollection with active dishes for render
      filtered_collection = @collection.where({ status: "active"})
      @dish_for_render.reset(filtered_collection)



    removeItem: (event) ->
      checkbox = event.target
      dish_id = +$(checkbox).closest('.dish_body').data("dish-id")
      model = @collection.get(dish_id)
      model.set(status: "inactive")
      @dish_for_render.remove(dish_id)


      this.filterCollection()

    addItem: (event) ->
      checkbox = event.target
      dish_id = +$(checkbox).closest('.dish_body').data("dish-id")
      input_number_selector = $(checkbox).closest(".dish_body").find("input[type='number']")
      quantity = input_number_selector.val()

      model = @collection.get(dish_id)
      model.set(status: "active")
      model.set(quantity: quantity)

      this.filterCollection()

      this.renderItems()

    calculatePrice: ->

      selected_tab_selector = $(".day_body[aria-hidden='false']")
      current_day = selected_tab_selector.find(".current_day").text()
      active_day_selector = $(".day_order."+current_day)

      price_for_day = active_day_selector.find(".price_for_dish").text()

      
      array = price_for_day.split(' ')

      #remove zero at the end of array
      array.pop()

      #convert string to number
      array = _.map(array, (n)-> Number(n))


      sum = _.reduce(array, (memo,num)-> memo+num)
      #change undefiend to zero if no items in pre-order
      sum = 0 if !sum

      order_total = active_day_selector.parent().find(".order_total")
      order_total.text(sum+" UAH")

      # create objects week_day: limit_balance
      ready_hash = _.object(@week_days, @limit_balance)

      remaining_balance_selector = active_day_selector.parent().find(".remaining_balance")
      balance = ready_hash[current_day]-sum

      this.disableSubmit(balance, active_day_selector)

      remaining_balance_selector.text(balance+" UAH")
      
    # disableSubmit button if balance<0
    disableSubmit: (balance,active_day_selector)->
      if balance<0
        $("button.btn.btn-primary").prop("disabled", true)
        active_day_selector.parent().addClass("overrun")
        active_day_selector.parent().prev().addClass("overrun")
      else
        $("button.btn.btn-primary").removeAttr("disabled")
        active_day_selector.parent().removeClass("overrun")
        active_day_selector.parent().prev().removeClass("overrun")


    renderItems: ->
      @view = new ItemView(collection: @dish_for_render)
      @view.$el = $('.dish_in_category-'+@category_id+'.day_order.'+@week_days[@day])
      @view.render()
      @view.delegateEvents()


    render: () ->
      @$el.html @template(dishes: @collection.toJSON(), day_id: @day_id)
