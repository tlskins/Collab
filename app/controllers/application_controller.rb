class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include PublicActivity::StoreController

  def controller_current_admin
    @current_admin = current_admin
  end

  helper_method :controller_current_admin
  hide_action :controller_current_admin

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  #configure permitted parameters for devise
  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me, :avatar, :avatar, :avatar_cache]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

end
