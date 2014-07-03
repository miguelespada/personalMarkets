module UsersHelper

  def user_likes(user)
    content_tag :div, class: "likes" do
      render template: "markets/index",
        :locals => {:markets => @user.favorites, :layout => "slugs"}
    end
  end

  def user_role(user)
    if current_user.has_role?(:admin) 
      'You are an ADMIN user'
    elsif current_user.has_role?(:premium)
      'You are a PRO user'
    else
      'You are a REGULAR user'
    end
  end
end
