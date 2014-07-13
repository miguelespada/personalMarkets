module PhotosHelper

  def all_photos_link
     link_to "All photos", photos_path, class: "btn btn-primary" if user_signed_in? && current_user.admin?
  end

  def user_photos_link(user)
    link_to "My photos", user_photos_path(user), class: "btn btn-primary" if user_signed_in?
  end

  def photo(photo, width, height = nil, params = {})
    height ||= width * 0.75
    size = "#{width.to_i}x#{height.to_i}"
    image_options = { size: size, crop: :fill, quality: 50, effect: params[:effect], radius: params[:radius] }
    crop = photo.crop if !photo.crop.nil?
    image_options = {transformation: { crop: :crop, x: crop["x"], y: crop["y"],
                       width: crop["w"], height: crop["h"]}, size: size, quality: 50, effect: params[:effect], radius: params[:radius]} if !crop.nil?
    cl_image_tag(photo.photo.path, image_options) 
    rescue
      image_tag "default-image.png", image_options
  end 

  def edit_photo_link(photo)
    if !photo.photo.nil? && (can? :edit, photo)
      link_to content_tag(:i, "", class: "fa fa-crop"), edit_photo_path(photo), class: "btn edit btn-danger btn-xs table-photo-edit"   
    end
  end

  def photographic_link(photo)
    if !photo.photographic.nil?
      link_to content_tag(:i, "", class: "fa fa-external-link-square"), photo.photographic, class: "btn btn-warning table-button btn-xs table-photo-photographic"
    end
  end

end