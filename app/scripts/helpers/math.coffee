define [
  'handlebars'
], (Handlebars) ->

  Handlebars.registerHelper 'math', (lvalue, operator, rvalue, options) ->
    lvalue = parseFloat(lvalue)
    rvalue = parseFloat(rvalue)
    {
      '+': lvalue + rvalue
      '-': lvalue - rvalue
      '*': lvalue * rvalue
      '/': lvalue / rvalue
      '%': lvalue % rvalue
    }[operator]
