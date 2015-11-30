define [
  'handlebars'
  'moment'
], (Handlebars, Moment) ->
  
  Handlebars.registerHelper('generateDate', (context, block) ->
      f = "DD_MM_YY"
      offset = block.hash.offset || 0
      Moment(new Date(context)).add(offset,'days').format(f)
  )
