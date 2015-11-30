define [
  'backbone'
 	'models/session'
], (Backbone, Session) ->
  class CateringRouter extends Backbone.Router
    routes:
      "": "login"
      "login": "login"
      "contacts": "contacts"
      "sprints": "sprints"
      "sprints/:id": "sprint"
      "sprints/:id/rations": "sprint_rations"
      "order/:id": "order"
