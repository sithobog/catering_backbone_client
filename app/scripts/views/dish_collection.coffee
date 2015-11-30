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
      "click .minus, .plus": "changeInputValue"
      "change input[type=number]": "updateQuantity"
      "keyup input[type=number]": "updateQuantity"
      "click .business_lunch" : "triggerBusinessLunch"
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
      dish_body = $(checkbox).closest('.dish_body')
      elements = dish_body.find('.trigger_disabled')
      if ($(checkbox)).is(":checked")
        elements.removeAttr('disabled')
        this.checkMinusButton(event)
        this.addItem(event)
      else
        elements.prop('disabled', true)
        this.removeItem(event)

      this.calculatePrice()

    changeInputValue: (event)->
      event.preventDefault()
      clicked_button = event.target
      number_input = $(clicked_button).closest('.number_field').find('input[type=number]')
      value_from_button = $(clicked_button).data("value")
      number_input.val(+number_input.val()+value_from_button)
      this.updateQuantity(event)

    checkMinusButton: (event) ->
      number_field = $(event.target).closest('.dish_body').find('.number_field')
      current_value = +number_field.find('input[type=number]').val()
      if current_value <= 1
        number_field.find(".minus").prop("disabled", true)
      else
        number_field.find(".minus").removeAttr("disabled")

    updateQuantity: (event) ->
      initiator = event.target
      dish_body = $(initiator).closest('.dish_body')
      dish_id = +dish_body.data("dish-id")
      input_number_selector = dish_body.find("input[type='number']")
      quantity = +input_number_selector.val()
      #prevent negative input
      if quantity < 1
        input_number_selector.val(1)
        quantity = 1

      model = @collection.get(dish_id)
      model.set(quantity: quantity)

      this.checkMinusButton(event)

      # re-calculate price
      this.calculatePrice()

    triggerBusinessLunch: ->
      business_lunch = $(event.target).closest(".dish_body")
      children = business_lunch.find(".children")
      children.slideToggle("slow")

    filterCollection: ->
      #fill DishCollection with active dishes for render
      filtered_collection = @collection.where({ status: "active"})
      @dish_for_render.reset(filtered_collection)



    removeItem: (event) ->
      checkbox = event.target
      dish_id = +$(checkbox).closest('.dish_body').data("dish-id")
      model = @collection.get(dish_id)
      model.set(status: "inactive", {silent: true})
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

      # create objects {week_day: limit_balance}
      ready_hash = _.object(@week_days, @limit_balance)

      remaining_balance_selector = active_day_selector.parent().find(".remaining_balance")
      balance = ready_hash[current_day]-sum

      this.disableSubmit(balance, active_day_selector)

      remaining_balance_selector.text(balance+" UAH")
      
    # disableSubmit button if balance<0
    disableSubmit: (balance,active_day_selector)->
      if balance<0
        $("button.btn.btn-primary").prop("disabled", true)
        active_day_selector.parent().addClass("outspend")
        active_day_selector.parent().prev().addClass("outspend")
      else
        $("button.btn.btn-primary").removeAttr("disabled")
        active_day_selector.parent().removeClass("outspend")
        active_day_selector.parent().prev().removeClass("outspend")
        this.checkOutspentDays()

    checkOutspentDays: ->
      overrun_days = $("#pre-order").find(".day_name.outspend")
      #keep submit disabled if some day is outspend
      if overrun_days.length != 0
        $("button.btn.btn-primary").prop("disabled", true)

    renderItems: ->
      @view = new ItemView(collection: @dish_for_render)
      @view.$el = $('.dish_in_category-'+@category_id+'.day_order.'+@week_days[@day])
      @view.render()
      @view.delegateEvents()

    render: () ->
      @$el.html @template(dishes: @collection.toJSON(), day_id: @day_id)
