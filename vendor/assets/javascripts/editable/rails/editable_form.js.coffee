unless EditableForm
  build_nested_param = (attr_to_update, updated_value, nest_def)->
    ret = {}
    last = ret
    if(Array.isArray(nest_def))
      for obj in nest_def
        attr = Object.keys(obj)[0]
        key = attr + "_attributes"
        id = obj[attr]
        last[key] = {id: id}
        last = last[key]
    else if (typeof nest_def == "object" && nest_def != null)
      attr = Object.keys(nest_def)[0]
      key = attr + "_attributes"
      id = nest_def[attr]
      last[key] = {id: id}
      last = last[key]

    last[attr_to_update] = updated_value
    ret

  EditableForm = $.fn.editableform.Constructor
  EditableForm.prototype.saveWithUrlHook = (value) ->
    originalUrl   = @options.url
    model         = @options.model
    nestedName    = @options.nested
    nestedId      = @options.nid
    nestDef       = @options.nestDef
    nestedLocale  = @options.locale

    @options.url = (params) =>
      if typeof originalUrl == 'function'
        originalUrl.call(@options.scope, params)
      else if originalUrl? && @options.send != 'never'
        myName = params.name
        myValue = params.value

        # if there are no values in a list, add a blank value so Rails knows all values were removed
        if Object.prototype.toString.call(params.value) == '[object Array]' && params.value.length == 0
          params.value.push("")

        obj = {}

        if nestDef
          obj = build_nested_param(myName, myValue, nestDef)
        else if nestedName
          nested          = {}
          nested[myName]  = myValue
          nested['id']    = nestedId

          if nestedLocale
            nested['locale'] = nestedLocale

          obj[nestedName + '_attributes'] = nested
        else
          obj[myName] = myValue

        params[model] = obj

        delete params.name
        delete params.value
        delete params.pk

        $.ajax($.extend({
          url:      originalUrl
          data:     params
          type:     'PUT'
          dataType: 'json'
        }, @options.ajaxOptions))

    @saveWithoutUrlHook(value)

  EditableForm.prototype.saveWithoutUrlHook = EditableForm.prototype.save
  EditableForm.prototype.save = EditableForm.prototype.saveWithUrlHook
