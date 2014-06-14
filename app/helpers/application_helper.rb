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
    content_tag :div, class:"col-md-offset-9" do
      link_to :back do
         content_tag :i, :class => "fa fa-reply fa-3x" do
        end 
      end
    end 
  end

   def before_form_link
    content_tag :div, class:"col-md-offset-9" do
      link_to  session[:my_previouse_url] do
         content_tag :i, :class => "fa fa-reply fa-3x" do
        end 
      end
    end 
  end


end


