module X
  module Editable
    module Rails
      module ViewHelpers  
        def editable model, object, method, options = {}
          if can? :edit, model and xeditable?
            data_url = polymorphic_path(object)
            object = object.last if object.kind_of?(Array)
            model_param = model.to_s.downcase.gsub('::', '_')
            model_name = model.to_s.downcase.gsub('::', '/')
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