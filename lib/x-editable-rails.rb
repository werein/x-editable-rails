require 'i18n'

require 'x-editable-rails/version'
require 'x-editable-rails/configuration'
require 'x-editable-rails/view_helpers'

I18n.load_path += Dir[File.expand_path File.join('..', 'locales', '*.yml'), File.dirname(__FILE__)]

module X
  module Editable
    module Rails
      class Engine < ::Rails::Engine
        initializer 'x-editable-rails.view_helpers' do
          ActionView::Base.send :include, ViewHelpers
        end
      end
    end
  end
end