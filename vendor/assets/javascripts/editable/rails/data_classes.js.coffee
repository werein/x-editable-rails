
# make things editable that can be edited

# $('.editable').editable(
  # success: (response, value) ->
    # element = $(this)
    # css = element.data('classes') || {}
    # element.removeClass(class_name) for key, class_name of css
    # element.addClass(css[value])
    # element.css('background-color', '')
# )

# swap CSS classes when the value changes

jQuery ($) ->
  $("[data-classes]").on "save", (e, data) ->
    console?.log('data', data, 'event', e)
    value = data.newValue
    element = $(this)
    css = element.data('classes') || {}
    element.removeClass(class_name) for key, class_name of css
    element.addClass(css[value])
    element.css('background-color', '')
    
