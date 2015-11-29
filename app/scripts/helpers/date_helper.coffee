define [
  'handlebars'
  'moment'
], (Handlebars, Moment) ->
  
  Handlebars.registerHelper('dateFormat', (context, block) ->
      f = block.hash.format || 'MMMM Do, YYYY'
      offset = block.hash.offset || 0
      Moment(new Date(context)).add(offset,'days').format(f)#.replace(/\//g,'.')
  )
