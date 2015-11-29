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
      array_for_hash = []
      _.each(data, (obj)->
        #create valid json from string
        stringified = JSON.stringify(eval('('+obj["name"]+')'))
        object = JSON.parse(stringified)

        #write sprint_id and quantity to object
        object["sprint_id"] = sprint_id
        object["quantity"] = obj["value"]

        #fill collection with ready element
        array_for_hash.push(object)
      )
      #prepare hash to send it on server
      hash_to_send = {}
      i = 0
      _.each(array_for_hash, (mod)->
        hash_to_send[i] = mod
        i++
      )

      this.sendData(hash_to_send)

    #this function triggers event that rations are saved on server
    sendData: (array)->
      this_url = @url
      $.ajax(
        type: "POST"
        url: this_url
        data: array
        success:(res) ->
          Backbone.pubSub.trigger('rations-saved')
        error: (res) ->
          console.log("error in POST")
          console.log(res)
      )
      return



      

