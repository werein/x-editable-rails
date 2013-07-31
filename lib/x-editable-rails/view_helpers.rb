module X
  module Editable
    module Rails
      module ViewHelpers  
        def editable model, object, method, options = {}
          if can? :edit, model and xeditable?
            model_param = model.to_s.downcase.gsub('::', '_')
            model_name = model.to_s.downcase.gsub('::', '/')
            data_url = options[:nested_model] ? polymorphic_path([options[:nested_model], object]) : polymorphic_path(object)     
            content_tag :a, href: "#", class: "editable", data: { type: 'text', model: model_param, name: method, url: data_url, 
              nested: (options[:nested] if options[:nested]), nid: (options[:nid] if options[:nid]), 'original-title' => t("activerecord.attributes.#{model_name}#{"/#{options[:nested].singularize}" if options[:nested]}.#{method}") } do
                object.send(method) 
            end
          else
            options[:e]
          end
        end
      end
    end
  end
end