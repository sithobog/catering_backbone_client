define [
  'underscore'
  'backbone'
  'models/daily_ration'
], (_, Backbone, DailyRationModel) ->

  class DailyRationsCollection extends Backbone.Collection
    model: DailyRationModel

    url: '/daily_rations'

    initialize: () ->
      self = this

      $.ajaxPrefilter( (options, originalOptions, jqXHR) ->
        options.xhrFields = { withCredentials: true }

        if sessionStorage.getItem('token')
          jqXHR.setRequestHeader('X-Auth-Token',
            sessionStorage.getItem('token'))
      )

      this.fetch(
        dataType: 'json',
        type: 'GET'
        success: (collection, xhr, options) ->
          console.log('Success')
          console.log(collection)
        error: (collection, xhr, options) ->
          console.log('Error')
          console.log(options)
          console.log(xhr)
      )
