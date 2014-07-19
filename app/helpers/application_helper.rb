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

  def back_link
    content_tag :div, class:"form-group col-md-4 col-md-offset-4 go-back-button-container" do
      link_to :back, class:"btn btn-default" do
        content_tag(:i, "", :class => "fa fa-reply") + " Go Back"
      end
    end 
  end

   def before_form_link
    content_tag :div, class:"form-group col-md-4 col-md-offset-4 go-back-button-container" do
      link_to session[:my_previouse_url], class:"btn btn-primary" do
        content_tag(:i, "", :class => "fa fa-reply") + " Go Back"
      end 
    end 
  end

  def search_or_map_page?
    (controller_name == 'markets' && action_name == 'search') || (controller_name == 'static_pages' && action_name == 'map')
  end

  def page_title(model)
    "<div class = 'page_title'><i class='fa #{model.icon} fa-2x'></i> <br/>#{model.title}</div>".html_safe
  end

end


