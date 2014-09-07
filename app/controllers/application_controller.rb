class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :set_locale
  protect_from_forgery with: :exception

  layout "theme"
  
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
  end

  def after_sign_in_path_for(resource)
    Tracker.sign_in current_user.email
    root_path
  end

  def set_locale
    params[:language] = I18n.default_locale unless  ["es", "en"].include?(params[:language])
    I18n.locale = params[:language] || I18n.default_locale
  end

  def default_url_options(options={})
    # logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { language: I18n.locale }
  end
end
