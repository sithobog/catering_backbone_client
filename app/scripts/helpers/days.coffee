define [
  'handlebars'
], (Handlebars) ->
	
	Handlebars.registerHelper('day_of_week', (day) ->
		_days = ["Monday", "Tuesday", "Wednesday", "Thursday"
		, "Friday", "Saturday", "Sunday"]
		_days[day]
	)
