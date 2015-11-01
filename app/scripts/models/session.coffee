define [
  'jquery'
  'backbone'
  'router'
], ($, Backbone, Router) ->
  SessionModel = Backbone.Model.extend(
    url: '/sessions'
    initialize: ->

      #Check for sessionStorage support
      if Storage and sessionStorage
        @supportStorage = true
      return

    login: (credentials) ->
      that = this
      _login = $.ajax(
        url: @url
        data: credentials
        type: 'POST'
        complete: (res) ->
          response = JSON.parse(res.responseText)
          if res.status == 201
            that.set("token", response.token)
            that.set("auth", true)
            console.log(that.toJSON())
          else if res.status == 401
            console.log("code 401")
        )
      return

  )
  new SessionModel

