$.fn.editable.defaults.error = (response, newValue) ->
  field_name = $(this).data("name")
  error_msgs = response.responseJSON.errors[field_name]
  error_msgs.join "; "