define [
  'jquery'
  'backbone'
  'router'
], ($, Backbone, Router) ->
  SessionModel = Backbone.Model.extend(
    url: '/sessions'

    initialize: ->
      self = this
      $.ajaxSetup({
        'beforeSend': (xhr) ->
          xhr.setRequestHeader("accept", "application/json");
      })

      $.ajaxPrefilter( (options, originalOptions, jqXHR) ->

        if self.get('token')?
          jqXHR.setRequestHeader('X-Auth-Token', self.get('token'))
      )

    login: (params) ->
      self = this

      this.fetch(
        data: params,
        dataType: 'json',
        type: 'POST'
        success: (model, xhr, options) ->
          console.log('Success')
          console.log(model)
          sessionStorage.setItem('token', model.get('token'))
          sessionStorage.setItem('name', model.get('name'))
        error: (model, xhr, options) ->
          console.log('Error')
          console.log(options)
          console.log(xhr)
      )

    logout: ->
      self = this
      _logout = $.ajax(
        url: @url
        type: 'DELETE'
        success:(res) ->
          self.clear()
          self.id = null
          sessionStorage.removeItem('token')
          sessionStorage.removeItem('name')
          console.log("success logout")
          console.log(res)
        error: (res) ->
          console.log("error in logout")
          console.log(res)
      )

    getAuth: ->
      self = this
      if (sessionStorage.getItem('token') && sessionStorage.getItem('name'))
        _token = sessionStorage.getItem('token')
        _name = sessionStorage.getItem('name')
        self.set({ auth: true, token: _token, name: _name })
  )
  new SessionModel

