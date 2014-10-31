module X
  module Editable
    module Rails
      module Configuration
        
        def method_options_for(object, method)
          class_options_for(object).fetch(method, {})
        end
        
        def class_options_for(object)
          class_options = options.fetch(:class_options, {})
          object = object.last if object.is_a?(Array)
          class_options.fetch(object.class.name, {})
        end
        
        def class_options
          options.fetch(:class_options, {})
        end
        
        def options
          config_fn = ::Rails.root.join("config", "x-editable.yml")
          if File.file?(config_fn)
            @options ||= begin
              options = load_yaml_file config_fn
              format_class_options! options
            end
          else
            @options = {}
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
        
        # if the specified options are a string, convert to Hash and make the string the title
        def format_class_options!(options)
          if class_options = options[:class_options]
            class_options.each do |class_name, methods|
              methods.each do |method, method_options|
                unless method_options.is_a? Hash
                  methods[method] = { title: method_options }.with_indifferent_access
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