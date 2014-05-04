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
  
  def hidden_bar
    "hidden" unless params[:controller] == "markets" && params[:action] == "search"
  end

  def photo(photo, width, height = nil)
    heihgt ||= width
    size = "#{width}x#{height}"
    image_options = { size: size, crop: :fill }
    if !photo.nil?
      cl_image_tag(photo.path, image_options) 
    else
      image_tag "default-image.png", image_options
    end
  end 
end

