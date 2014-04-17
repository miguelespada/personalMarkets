module ApplicationHelper
  def page_title(title)
    content_for :page_title, title
    "<h4>#{title}</h4>".html_safe
  end
  
  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end
  def resource
    @resource ||= User.new
  end
end
