$.fn.editable.defaults.error = (response, newValue) ->
  nested = $(this).data('nested')
  if(Array.isArray(nested))
    keys = nested.map((obj)-> Object.keys(obj)[0])
    keys.push($(this).data("name"))
    field_name = keys.join(".")
  else if (typeof nested == "object" && nested != null)
    key = Object.keys(nested)[0]
    field_name = key + "." + $(this).data("name")
  else
    field_name = $(this).data("name")

  error_msgs = response.responseJSON.errors[field_name]
  error_msgs.join "; "
