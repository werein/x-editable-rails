module X
  module Editable
    module Rails
      module ViewHelpers  
        def editable object, method, options = {}
          data_url = polymorphic_path(object)
          object = object.last if object.kind_of?(Array)
          if can? :edit, object and xeditable?
            model = object.class.to_s.downcase
            model_param = model.gsub('::', '_')
            klass = options[:nested] ? object.class.const_get(options[:nested].to_s.singularize.capitalize) : object.class
            content_tag :a, href: '#', class: 'editable', title: options.fetch(:title, klass.human_attribute_name(method)),
            data: { 
              type: options.fetch(:type, 'text'), 
              model: model_param, 
              name: method, 
              url: data_url, 
              nested: options[:nested], 
              nid: options[:nid]
            } do
                object.send(method).try(:html_safe)
            end
          else
            options[:e]
          end
        end
      end
    end
  end
end