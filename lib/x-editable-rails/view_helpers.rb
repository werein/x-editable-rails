module X
  module Editable
    module Rails
      module ViewHelpers  
        def editable(object, method, options = {})
          data_url = polymorphic_path(object)
          object   = object.last if object.kind_of?(Array)
          
          value = object.send(method)
          value = value.html_safe if value.respond_to? :html_safe
          
          if xeditable? and can?(:edit, object)
            model_param = object.class.name.split('::').last.underscore
            klass = options[:nested] ? object.class.const_get(options[:nested].to_s.singularize.capitalize) : object.class
            
            tag   = options.fetch(:tag, 'span')
            title = options.fetch(:title, klass.human_attribute_name(method))
            data  = { 
              type:   options.fetch(:type, 'text'), 
              model:  model_param, 
              name:   method, 
              url:    data_url, 
              nested: options[:nested], 
              nid:    options[:nid]
            }.merge options.fetch(:data, {})
            
            content_tag tag, class: 'editable', title: title, data: data do
              value
            end
          else
            options.fetch(:e, value)
          end
        end
      end
    end
  end
end
