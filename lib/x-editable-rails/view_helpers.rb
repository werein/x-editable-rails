require 'base64'

module X
  module Editable
    module Rails
      module ViewHelpers
        #
        # Options determine how the HTML tag is rendered and the remaining options are converted to data-* attributes.
        #
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
          # merge data attributes for backwards-compatibility
          options.merge! options.delete(:data){ Hash.new }

          url     = options.delete(:url){ polymorphic_path(object) }
          object  = object.last if object.kind_of?(Array)
          error   = options.delete(:e)
          html_options = options.delete(:html){ Hash.new }

          if xeditable?(object)
            model    = object.class.model_name.param_key
            nid      = options.delete(:nid)
            nested   = options.delete(:nested)
            nest_def = options.delete(:nest_def)

            deepest_obj = nest_def ? dig_nested_obj(object, nest_def) : object
            value = options.delete(:value){
              nest_def ?  deepest_obj.send(method) : object.send(method)
            }
            source  = options[:source] ? format_source(options.delete(:source), value) : default_source_for(value)
            classes = format_source(options.delete(:classes), value)


            title    = options.delete(:title) do
              if nest_def
                klass = nest_def.is_a?(Array) ? object.class.const_get(nest_def.last.keys.first.to_s.classify) : object.class.const_get(nest_def.keys.first.to_s.classify)
              else
                klass = nested ? object.class.const_get(nested.to_s.classify) : object.class
              end
              klass.human_attribute_name(method)
            end

            output_value = output_value_for(value)
            css_list = options.delete(:class).to_s.split(/\s+/).unshift('editable')
            css_list << classes[output_value] if classes
            type = options.delete(:type){ default_type_for(value) }
            css   = css_list.compact.uniq.join(' ')
            tag   = options.delete(:tag){ 'span' }
            placeholder = options.delete(:placeholder){ title }

            # any remaining options become data attributes
            data  = {
              type:   type,
              model:  model,
              name:   method,
              value:  ( type == 'wysihtml5' ? Base64.encode64(output_value) : output_value ),
              placeholder: placeholder,
              classes: classes,
              source: source,
              url:    url,
              nested: nested,
              nid:    nid,
              nest_def: nest_def
            }.merge(options.symbolize_keys)

            data.reject!{|_, value| value.nil?}

            html_options.update({
              class: css,
              title: title,
              data: data
            })

            content_tag tag, html_options do
              if %w(select checklist).include?(data[:type].to_s) && !source.is_a?(String)
                source = normalize_source(source)
                content = source.detect { |t| output_value == output_value_for(t[0]) }
                content.present? ? content[1] : ""
              else
                safe_join(source_values_for(value, source), tag(:br))
              end
            end
          else
            error || safe_join(source_values_for(value || options[:emptytext], source), tag(:br))
          end
        end

        private

        def normalize_source(source)
          return [] unless source
          source.map do |el|
            if el.is_a? Array
              el
            else
              [el[:value], el[:text]]
            end
          end
        end

        def output_value_for(value)
          value = case value
          when TrueClass
            '1'
          when FalseClass
            '0'
          when NilClass
            ''
          when Array
            value.map{|item| output_value_for item}.join(',')
          else
            value.to_s
          end

          value
        end

        def source_values_for(value, source = nil)
          source ||= default_source_for value

          values = Array.wrap(value)

          if source && ( source.first.is_a?(String) || source.kind_of?(Hash) )
            values.map{|item| source[output_value_for item]}
          else
            values
          end
        end

        def default_type_for(value)
          case value
          when TrueClass, FalseClass
            'select'
          when Array
            'checklist'
          else
            'text'
          end
        end

        def default_source_for(value)
          case value
          when TrueClass, FalseClass
            { '1' => 'Yes', '0' => 'No' }
          end
        end

        def dig_nested_obj(obj, nested)
          case(nested)
            when Array
              obj = nested.inject(obj){|memo, n|
                attr = n.keys.first
                id = n.values.first
                case(memo.class.reflect_on_association(attr))
                  when ActiveRecord::Reflection::HasOneReflection
                    memo = memo.send(attr)
                  when ActiveRecord::Reflection::HasManyReflection
                    memo = memo.send(attr).find_by(id: id)
                end
                memo
              }
            when Hash
              attr = nested.keys.first
              id = nested.values.first
              obj = case(obj.class.reflect_on_association(attr))
                when ActiveRecord::Reflection::HasOneReflection
                  obj.send(attr)
                when ActiveRecord::Reflection::HasManyReflection
                  obj.send(attr).find_by(id: id)
              end
          end
          return obj
        end

        # helper method that take some shorthand source definitions and reformats them
        def format_source(source, value)
          formatted_source = case value
            when TrueClass, FalseClass
              if source.is_a?(Array) && source.first.is_a?(String) && source.size == 2
                { '1' => source[0], '0' => source[1] }
              end
            else
              if source.is_a?(Array) && source.first.is_a?(String)
                source.map { |v| { value: v, text: v } }
              end
            end

          formatted_source || source
        end

      end
    end
  end
end
