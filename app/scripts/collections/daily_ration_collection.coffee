define [
  'underscore'
  'backbone'
  'models/daily_ration'
], (_, Backbone, DailyRationModel) ->

  class DailyRationCollection extends Backbone.Collection
    model: DailyRationModel

    url: '/daily_rations'

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

    save: (params) ->
      # prepare params for post method
      data = params
      data = data.replace(/%5B/g,"[")
      data = data.replace(/%5D/g,"]")

      $.post(@url,data)
