module PhotosHelper

  def all_photos_link
     link_to "All photos", photos_path if user_signed_in? && current_user.admin?
  end

  def user_photos_link(user)
    link_to "My photos", user_photos_path(user) if user_signed_in?
  end
end