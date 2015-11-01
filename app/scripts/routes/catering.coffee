define [
  'backbone'
], (Backbone) ->
  class CateringRouter extends Backbone.Router
    routes:
      "login": "login"
      "contacts": "contacts"
      "sprints": "sprints"
