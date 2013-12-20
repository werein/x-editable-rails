class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def xeditable? object = nil
    xeditable = params[:denied] ? false : true
    can?(:edit, object) and xeditable ? true : false
  end
  helper_method :xeditable?

  def can? edit, model
    true
  end
  helper_method :can?
end