class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout "theme"
  
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
  end

  def after_sign_in_path_for(resource)
    Keen.publish_async(:sign_ups, { :username => current_user.email, :at => Time.now })
    root_path
  end
end
