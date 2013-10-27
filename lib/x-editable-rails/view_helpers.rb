module X
  module Editable
    module Rails
      module ViewHelpers
        # options:
        #   tag:   tag name of element returned
        #   class: "class" attribute on element
        #   placeholder: "placeholder" attribute on element
        #   title: "title" attribute on element (defaults to placeholder)
        #   data:  "data-*" attributes on element
        #     source: a Hash of friendly display values used by input elements based on (object) value
        #       - boolean shorthand ['Enabled', 'Disabled'] becomes { '1' => 'Enabled', '0' => 'Disabled' }
        #       - enumerable shorthand ['Yes', 'No', 'Maybe'] becomes { 'Yes' => 'Yes', 'No' => 'No', 'Maybe' => 'Maybe' }
        #     classes: a Hash of classes to add based on the value (same format and shorthands as source)
        #   value: override the object's value
        #   
        def editable(object, method, options = {})
          options = Configuration.method_options_for(object, method).deep_merge(options).with_indifferent_access
          
          url     = polymorphic_path(object)
          object  = object.last if object.kind_of?(Array)
          value   = options.delete(:value){ object.send(method) }
          data    = options.fetch(:data, {})
          source  = data[:source] ? format_source(data.delete(:source), value) : default_source_for(value)
          classes = format_source(data.delete(:classes), value)
          
          if xeditable? and can?(:edit, object)
            model = object.class.name.split('::').last.underscore
            klass = options[:nested] ? object.class.const_get(options[:nested].to_s.singularize.capitalize) : object.class
            
            output_value = output_value_for(value)
            css_list = options[:class].to_s.split(/s+/).unshift('editable')
            css_list << classes[output_value] if classes
            
            css   = css_list.compact.uniq.join(' ')
            tag   = options.fetch(:tag, 'span')
            placeholder = options.fetch(:placeholder){ klass.human_attribute_name(method) }
            title = options.fetch(:title){ placeholder }
            data  = {
              type:   options.fetch(:type, 'text'), 
              model:  model, 
              name:   method, 
              value:  output_value, 
              placeholder: placeholder, 
              classes: classes, 
              source: source, 
              url:    url, 
              nested: options[:nested], 
              nid:    options[:nid]
            }.merge(data)
            
            data.reject!{|_, value| value.nil?}
            
            content_tag tag, class: css, title: title, data: data do
              source_value_for(value, source)
            end
          else
            # create a friendly value using the source to display a default value (if no error message given)
            options.fetch(:e){ source_value_for(value, source) }
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
        
        def source_value_for(value, source = nil)
          source ||= default_source_for value
          source ? source[output_value_for value] : value
        end
        
        def default_source_for(value)
          case value
          when TrueClass, FalseClass
            { '1' => 'Yes', '0' => 'No' }
          end
        end
        
        # helper method that take some shorthand source definitions and reformats them
        def format_source(source, value)
          formatted_source = case value
            when TrueClass, FalseClass
              if source.is_a?(Array) && source.first.is_a?(String) && source.size == 2
                { '1' => source[0], '0' => source[1] }
              end
            when String
              if source.is_a?(Array) && source.first.is_a?(String)
                source.inject({}){|hash, key| hash.merge(key => key)}
              end
            end
          
          formatted_source || source
        end
        
      end
    end
  end
end
