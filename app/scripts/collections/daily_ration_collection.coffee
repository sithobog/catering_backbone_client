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

    fillCollection: (params) ->
      data = params
      #grab sprint_id from first array's element
      sprint_id = data.shift()["value"]
      console.log("Sprint id is ...")
      console.log(sprint_id)
      future_collection = []
      _.each(data, (obj)->
        #create valid json from string
        stringified = JSON.stringify(eval('('+obj["name"]+')'))
        object = JSON.parse(stringified)

        #write sprint_id and quantity to object
        object["sprint_id"] = sprint_id
        object["quantity"] = obj["value"]

        model = new DailyRationModel()
        model.set(object)

        #fill collection with ready element
        future_collection.push(model)
      )

      #save collection on server
      this.create(future_collection)

      #prepare collection for render
      this.reset(future_collection)

