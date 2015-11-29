define [
  'underscore'
  'backbone'
  'models/order'
], (_, Backbone, OrderModel) ->

  class OrderCollection extends Backbone.Collection
    model: OrderModel

    url: '/orders'

    initialize: (options) ->
      self = this
      @sprint = options.sprint
      sprint_id = @sprint.id
      @response = "nope"
      $.ajaxSetup({
        'beforeSend': (xhr) ->
          xhr.setRequestHeader("accept", "application/json")
      })

      $.ajaxPrefilter( (options, originalOptions, jqXHR) ->

        jqXHR.setRequestHeader('X-Sprint', sprint_id)

        if sessionStorage.getItem('token')?
          jqXHR.setRequestHeader('X-Auth-Token', sessionStorage.getItem('token'))
      )


    fetch: ->
      self = this
      model_array = new Array()

      $.ajax(
        url: @url
        type: 'GET'
        dataType: 'json'
        success:(res) ->
          self.response = res
        error: (res) ->
          console.log("error in fetch")
          console.log(res)
      ).then(()->
        _.each(self.response, (elem)->
          model = new OrderModel()
          model.set({order_item: elem})
          model.set({day_number: elem[0]["day_number"]})
          model_array.push(model)
        )
        self.reset(model_array)
      )
