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
    "snavbar-hidden" unless ( params[:action] == "search" || 
                             params[:action] == "map")
  end

  def photo(photo, width, height = nil, effect = nil, crop_mode = :scale)
    height ||= width
    size = "#{width}x#{height}"
    image_options = { size: size, crop: :scale, effect: effect }
    crop = photo.crop if !photo.crop.nil?
    image_options = {transformation: { crop: :crop, x: crop["x"], y: crop["y"],
                       width: crop["w"], height: crop["h"]}, size: size, crop: :pad, effect: effect} if !crop.nil?
    cl_image_tag(photo.photo.path, image_options) 
    rescue
      image_tag "default-image.png", image_options
  end 

  def edit_photo_link(photo)
    if !photo.photo.nil?
      link_to content_tag(:i, "", class: "fa fa-crop"), edit_photo_path(photo), class: "btn edit btn-info btn-xs table-photo-edit"   
    end
  end

  def photographic_link(photo)
    if !photo.photographic.nil?
      link_to content_tag(:i, "", class: "fa fa-folder-o"), photo.photographic, class: "btn btn-default table-button"
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

  def twitter_text(market)
    "http://twitter.com/home?status=@PersonalMarkets, #{market.short_url}, %23#{market.name.tr(' ', '_').camelize}: #{market.description}"
  end

  def pinterest_text(market)
    "http://pinterest.com/pin/create/link/?url=#{market_url}&media=#{cloudinary_url(market.featured.photo.path)}&description=Personal Markets: #{market.name}, #{market.description}"
  end

  def google_text(market)
    "https://plus.google.com/share?url=#{market_url}"
  end

end


