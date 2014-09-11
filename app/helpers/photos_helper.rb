module PhotosHelper



  def photo(photo, width, height = nil, params = {})
    height ||= width / photo.aspect_ratio

    size = "#{width.to_i}x#{height.to_i}"
    if photo.crop.nil? 
      image_options = { size: size, crop: :fill, quality: 50, effect: params[:effect], radius: params[:radius] }
    else
      crop = photo.crop
      image_options = {transformation: { crop: :crop, x: crop["x"], y: crop["y"],
                       width: crop["w"], height: crop["h"]}, 
                       size: size, crop: :fill, 
                       quality: 50, effect: params[:effect], radius: params[:radius]} 
    end

    cl_image_tag(photo.photo.path, image_options) 
    rescue
      image_tag "default-image.png", image_options
  end 

  def edit_photo_link(photo)
    if !photo.photo.nil? && (can? :edit, photo)
      link_to content_tag(:i, "", class: "fa fa-crop"), edit_photo_path(photo), 
      class: "btn edit btn-info btn-xs photo-action"   
    end
  end

  def photographic_link(photo)
    if !photo.photographic.nil? && (can? :edit, photo)
      link_to content_tag(:i, "", class: "fa fa-external-link-square"), photo.photographic, 
      class: "btn btn-warning table-button btn-xs photo-action"
    end
  end

  def delete_photo_link(photo)
    if !photo.photographic.nil? && (can? :edit, photo)
      link_to content_tag(:i, "", class: "fa fa-trash-o"), photo, :method => :delete, 
        class: "delete btn btn-danger btn-xs photo-action", data:{ confirm: 'Are you sure?'}
    end
 end

  def all_photos_link
     link_to "All photos", photos_path, class: "btn btn-default" if user_signed_in? && current_user.admin?
  end

  def user_photos_link(user)
    link_to "My photos", user_photos_path(user), class: "btn btn-default" if user_signed_in?
  end
end