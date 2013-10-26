module X
  module Editable
    module Rails
      module ViewHelpers  
        def editable(object, method, options = {})
          url     = polymorphic_path(object)
          object  = object.last if object.kind_of?(Array)
          value   = options.delete(:value){ object.send(method) }
          
          if xeditable? and can?(:edit, object)
            model = object.class.name.split('::').last.underscore
            klass = options[:nested] ? object.class.const_get(options[:nested].to_s.singularize.capitalize) : object.class
            
            output_value = output_value_for(value)
            tag   = options.fetch(:tag, 'span')
            title = options.fetch(:title, klass.human_attribute_name(method))
            data  = { 
              type:   options.fetch(:type, 'text'), 
              model:  model, 
              name:   method, 
              value:  output_value, 
              url:    url, 
              nested: options[:nested], 
              nid:    options[:nid]
            }.merge options.fetch(:data, {})
            
            content_tag tag, class: 'editable', title: title, data: data do
              safe_value
            end
          else
            options.fetch(:e, value)
          end
        end
        
        private
        
        def output_value_for(value)
          value = case value
          when TrueClass
            '1'
          when FalseClass
            '0'
          when NilClass
            ''
          else
            value.to_s
          end
          
          value.html_safe
        end
      end
    end
  end
end
