define [
  'handlebars'
], (Handlebars) ->
	
	Handlebars.registerHelper('day_of_week', (day) ->
		_days = ["monday", "tuesday", "wednesday", "thursday"
		, "friday", "saturday", "sunday"]
		_days[day]
	)
