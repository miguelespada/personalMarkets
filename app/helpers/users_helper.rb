module UsersHelper

  def user_role(user)
    if user.has_role?(:admin) 
      'You are an ADMIN user'
    elsif user.has_role?(:premium)
      'You are a PRO user'
    else
      'You are a REGULAR user'
    end
  end

  def big_button(model)
    link_to send("#{model.model_name.route_key}_path"), class:"dashboard-button dashboard-button btn btn-primary btn-lg" do
      concat content_tag :i, "", class:"fa #{model.icon} fa-4x"
      concat "<br/>".html_safe
      concat truncate(model.model_name.human.pluralize,  length: 12)
    end 
  end
  
  def user_dashboard_link(action, text, icon)
    link_to send(action, current_user), class:"dashboard-button btn btn-lg" do
      concat content_tag :i, "", class:"fa #{icon} fa-4x"
      concat "<br/>".html_safe
      concat truncate(text,  length: 12)
    end 
  end

  def published_markets_status(user)
    content_tag :p, "" do
      concat "You have published: "
      concat user.number_of_last_month_markets 
      concat " market(s) during the last month"
      concat "</br>".html_safe
      concat "You can publish: " 
      concat current_user.remaining_markets
      concat " market(s)"
    end
  end


end
