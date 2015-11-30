define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  'bootstrap'

  'models/session'
], ($, _, Backbone, JST, Bootstrap, Session) ->
  class PanelView extends Backbone.View
    template: JST['app/scripts/templates/panel.hbs']

    events: 
      'click .logout': 'logout'

    initialize: () ->

    render: () ->
      @$el.html @template({username: Session.get('name')})

    logout: (event) ->
      $(event.currentTarget).text('Loading ...').prop('disabled', true)
      Session.logout()
