module ApplicationHelper
  
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
    link_to :back, class:"btn btn-default" do
      content_tag(:i, "", :class => "fa fa-reply") + " Go Back"
    end
  end

  def before_form_link
    link_to session[:my_previouse_url], class:"btn btn-default" do
      content_tag(:i, "", :class => "fa fa-reply") + " Go Back"
    end 
  end

  def search_or_map_page?
    (controller_name == 'markets' && action_name == 'search') || (controller_name == 'static_pages' && action_name == 'map')
  end

  # Entities

  def page_title(text, icon)
    content_tag :h1, "" do
      concat content_tag :i, "", class:"fa #{icon} fa-2x"
      concat "<br/>".html_safe
      concat text
    end
  end

  def action_title(model)
    content_tag :h1, "" do
      concat content_tag :i, "", class:"fa #{model.icon} fa-2x"
      concat "<br/>".html_safe
      concat params['action'].titleize
      concat " ".html_safe
      concat model.model_name.human
    end
  end

  def table_user
      concat "Your " if params['user_id'].present? && params['user_id'] == current_user.id.to_s
      concat User.find(params['user_id']).name + " " if params['user_id'].present? && params['user_id'] != current_user.id.to_s
      concat "All " if !params['user_id'].present?
  end

  def entity_table_header(model, new_action)
    content_tag :div, class: "panel-heading table-title" do
      concat link_to "<i class='fa fa-dashboard fa-1x'></i>".html_safe, user_dashboard_path(current_user)
      concat link_to "<i class='fa fa-cog fa-1x'></i>".html_safe, admin_path if current_user.has_role?(:admin)
      table_user
      concat model.model_name.human.pluralize
      if new_action.present?
        concat link_to content_tag(:i, " New", class: "fa fa-plus"), new_action, class: "new btn btn-info table-button table-button-new"
      end
    end
  end 

  def form(entity)
    render 'scaffolds/form', entity: entity, action: params['action']
  end

  def table(entities)
    render 'scaffolds/table', entities: entities, model: entities.klass
  end

end


