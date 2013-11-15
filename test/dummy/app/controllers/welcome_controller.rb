class WelcomeController < ApplicationController
  def index
    @pages = Page.all
  end
end
