define [
  'underscore'
  'backbone'
  'models/day'
], (_, Backbone, DayModel) ->

  class DaysCollection extends Backbone.Collection
    model: DayModel

    url: '/days'

    initialize: () ->
      self = this

      $.ajaxSetup({
        'beforeSend': (xhr) ->
          xhr.setRequestHeader("accept", "application/json")
      })

      $.ajaxPrefilter( (options, originalOptions, jqXHR) ->

        if sessionStorage.getItem('token')?
          jqXHR.setRequestHeader('X-Auth-Token', sessionStorage.getItem('token'))
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
