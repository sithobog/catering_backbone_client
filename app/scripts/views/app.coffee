define [
  'jquery'
], ($) ->
  class AppView
   showView: (view) ->
      if this.currentView
        this.currentView.close()
      this.currentView = view
      this.currentView.render()
      $('#main-part').html(this.currentView.el)
      return
  return new AppView()
