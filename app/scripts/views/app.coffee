define [
  'jquery'
], ($) ->
  class AppView
   showView: (view, element, events) ->
      if this.currentView
        this.currentView.close()
      this.currentView = view
      if element != undefined
        console.log("EVENTS IS ....")
        console.log(events)
        console.log(this.currentView)
        this.currentView.$el = element
        this.currentView.render()
        if events != undefined
          this.currentView.delegateEvents(events)
      else
        console.log("ELSE BRANCH")
        this.currentView.render()
      $('#main-part').html(this.currentView.el)
      return
  return new AppView()
