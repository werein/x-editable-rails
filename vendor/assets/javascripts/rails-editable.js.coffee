jQuery ($) ->
  EditableForm = $.fn.editableform.Constructor
  EditableForm.prototype.saveWithUrlHook = (value) ->
    url = @options.url
    model = @options.model
    nestedName = @options.nested
    nestedId =  @options.nid
    @options.url = (params) =>
      obj = {}
      if nestedName
        nested = {}
        nested[params.name] = params.value
        nested['id'] = nestedId
        obj[nestedName + '_attributes'] = nested
      else
        obj[params.name] = params.value
      params[model] = obj
      delete params.name
      delete params.value
      delete params.pk
      $.ajax($.extend({
      url     : url
      data    : params
      type    : 'PUT'
      dataType: 'json'
      }, @options.ajaxOptions))
    @saveWithoutUrlHook(value)
  EditableForm.prototype.saveWithoutUrlHook = EditableForm.prototype.save
  EditableForm.prototype.save = EditableForm.prototype.saveWithUrlHook