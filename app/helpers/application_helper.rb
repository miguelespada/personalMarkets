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
    "snavbar-hidden" unless params[:controller] == "markets" && params[:action] == "search"
  end

  def photo(photo, width, height = nil)
    height ||= width
    size = "#{width}x#{height}"
    image_options = { size: size, crop: :pad }
    if !photo.photo.nil?
      crop = photo.crop if !photo.crop.nil?
      image_options = {transformation: { crop: :crop, x: crop["x"], y: crop["y"],
                       width: crop["w"], height: crop["h"]}, size: size, crop: :pad} if !crop.nil?
      cl_image_tag(photo.photo.path, image_options) 
    else
      image_tag "default-image.png", image_options
    end

  end 

  def edit_photo_link(photo)
    if !photo.photo.nil?
      link_to content_tag(:i, "", class: "fa fa-pencil"), edit_photo_path(photo), class: "btn edit btn-info btn-xs table-photo-edit"   
    end
  end

  def back_link
    content_tag :div, class:"col-md-offset-9" do
      link_to :back do
         content_tag :i, :class => "fa fa-reply fa-3x" do
        end 
      end
    end 
  end

end


