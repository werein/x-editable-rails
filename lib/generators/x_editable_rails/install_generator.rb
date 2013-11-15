module XEditableRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'Copy example of x-editable config'
      def copy_x_editable_yml
        template 'x-editable.yml', 'config/x-editable.yml'
      end   
    end
  end
end