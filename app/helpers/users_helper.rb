module UsersHelper

  def user_likes(user)
    content_tag :div, class: "likes" do
      render template: "markets/index",
        :locals => {:markets => @user.favorites, :layout => "slugs"}
    end
  end
end
