bool = (tag, val) ->
  if !val?
    ''
  else if val is false
    ''
  else if typeof val is 'object' and _.isEmpty(val)
    ''
  else
    new Handlebars.SafeString "#{tag}=\"#{tag}\""

Handlebars.registerHelper
  bool: (tag, val) -> bool tag, val
  checked: (val) -> bool 'checked', val
  selected: (val) -> bool 'selected', val
