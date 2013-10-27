require 'x-editable-rails/version'
require 'x-editable-rails/configuration'
require 'x-editable-rails/view_helpers'

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
