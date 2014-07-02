module UsersHelper

  def user_likes(user)
    content_tag :div, class: "likes" do
      render template: "markets/index",
        :locals => {:markets => @user.favorites, :layout => "slugs"}
    end
  end

  def user_title(user)

    if current_user.has_role?(:admin) 
      '<h3 class="center"> You are an ADMIN user</h3>'.html_safe()
    elsif current_user.has_role?(:premium)
      '<h3 class="center"> You are a PRO user</h3>'.html_safe()
    else
      '<h3 class="center"> You are a REGULAR user</h3>'.html_safe()
    end

  end
end
