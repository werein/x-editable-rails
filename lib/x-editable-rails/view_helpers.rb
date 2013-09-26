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

            title = options.fetch(:title) { "Click to edit" }

            data_options = {
              type: 'text',
              model: model_param,
              name: method,
              url: data_url,
              nested: (options[:nested] if options[:nested]),
              nid: (options[:nid] if options[:nid]),
              :'original-title' => klass.human_attribute_name(method)
            }

            link_options = {
              href: "#",
              class: "editable",
              title: title,
              data:  data_options
            }

            content_tag(:a, object.send(method), link_options)
          else
            options[:e]
          end
        end
      end
    end
  end
end
