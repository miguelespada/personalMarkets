module UsersHelper

  def user_role(user)
    if user.has_role?(:admin)
      t(:you_are_admin) 
    elsif user.has_role?(:premium)
      t(:you_are_pro)
    else
      t(:you_are_regular)
    end
  end

  def published_markets_status(user)
    content_tag :p, "" do
      concat t(:you_have_published)
      concat " "
      concat user.number_of_last_month_markets 
      concat " "
      concat t(:market_s)
      concat " "
      concat t(:during_last_month)
      concat "</br>".html_safe
      concat t(:you_can_publish)
      concat " "
      concat user.remaining_markets
      concat " "
      concat t(:market_s)
    end
  end

  def days_to_wait(user)
    content_tag :p, "" do
      concat t(:you_have_to_wait)
      concat " "
      concat user.days_until_can_create_new_market
      concat " "
      concat t(:day).pluralize(user.days_until_can_create_new_market)
      concat " "
      concat t(:to_create_new_markets)
    end
  end

  def too_many_drafts(user)
    content_tag :p, "" do
      concat t(:currently_you_have)
      concat " "
      concat user.number_of_drafts
      concat " "
      concat t(:drafts)
      concat ". "
      concat t(:each_user_can_have)
      concat " 5 "
      concat t(:drafts)
      concat " "
      concat t(:only)
    end
  end

  def too_many_wishes_message(user)
    content_tag :p, "" do
      concat t(:currently_you_have)
      concat " "
      concat user.wishes.count
      concat " "
      concat t(:wishes)
      concat ". "
      concat t(:each_user_can_have)
      concat " 10 "
      concat t(:wishes)
      concat " "
      concat t(:only)
    end
  end

  def too_many_bargains_message(user)
    content_tag :p, "" do
      concat t(:currently_you_have)
      concat " "
      concat user.bargains.count
      concat " "
      concat t(:bargains)
      concat ". "
      concat t(:each_user_can_have)
      concat " 10 "
      concat t(:bargains)
      concat " "
      concat t(:only)
    end
  end

  def admin_link(model)
    link_to send("#{model.model_name.route_key}_path"), class:"dashboard-button btn btn-lg" do
      concat content_tag :i, "", class:"fa #{model.icon} fa-4x"
      concat "<br/>".html_safe
      concat truncate(t(model.model_name.human.downcase).capitalize.pluralize, length: 12)
    end 
  end
  
  def current_user_dashboard_link(action, text, icon)
    user_dashboard_link(action, current_user, text, icon)
  end

  def user_dashboard_link(action, user, text, icon)
    link_to send(action, user), class:"dashboard-button btn btn-lg" do
      concat content_tag :i, "", class:"fa #{icon} fa-4x"
      concat "<br/>".html_safe
      concat truncate(text,  length: 12)
    end 
  end

  def external_link(ref, text, icon)
    link_to ref, class:"dashboard-button btn btn-lg",  :target => "_blank" do
      concat content_tag :i, "", class:"fa #{icon} fa-4x"
      concat "<br/>".html_safe
      concat truncate(text,  length: 12)
    end
  end
end