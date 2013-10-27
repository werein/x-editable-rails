module X
  module Editable
    module Rails
      module Configuration
        
        def method_options_for(object, method)
          class_options_for(object).fetch(method, {})
        end
        
        def class_options_for(object)
          class_options = options.fetch(:class_options, {})
          class_options.fetch(object.class.name, {})
        end
        
        def class_options
          options.fetch(:class_options, {})
        end
        
        def options
          default_options.deep_merge custom_options
        end
        
        def default_options
          @defaults ||= begin
            options = load_yaml_file File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "x-editable.yml"))
            format_class_options! options
          end
        end
        
        def custom_options
          @custom_options ||= begin
            options = load_yaml_file ::Rails.root.join("config", "x-editable.yml")
            format_class_options! options
          end
        end
        
        def load_yaml_file(path)
          source = File.read path
          source = ERB.new(source).result
          
          result = YAML.load(source)
          result = {} if result.blank?
          
          result.with_indifferent_access
        end
        
        private
        
        # class options can have string as the placeholder by default, convert to Hash
        def format_class_options!(options)
          if class_options = options[:class_options]
            class_options.each do |class_name, methods|
              methods.each do |method, method_options|
                unless method_options.is_a? Hash
                  methods[method] = { placeholder: method_options }.with_indifferent_access
                end
              end
            end
          end
          
          options
        end
        
        extend self
      end
    end
  end
end