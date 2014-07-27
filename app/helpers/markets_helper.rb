module MarketsHelper
  def tooltip(market)
    div_for market, class: "market-tooltip" do
      render :partial => 'markets/shared/views/tooltip',
             :formats => [:html], 
             :locals => {:market => market.decorate}
    end
  end

  def save_and_publish_button(form, market)
      if params[:action] == "edit"
        form.button :submit, "Update Market and Publish", class: 'btn btn-info', id: 'save-and-publish-button'
        else
           '<div class="center tip"><i class="fa fa-arrow-circle-right"></i> Recuerda que una vez guardado, 
              deberas "Publicar" tu Market para que sea visible!
              </br> <i class="fa fa-arrow-circle-right"></i> Una vez guardado podrás modificar cualquiera de los campos.</div>'.html_safe
      end
  end

  def format_date(day)
    day["date"].to_formatted_s(:rfc822)  + ": " + day["from"] + " - " + day["to"]
  end

  def append_date(day)
     ", " + day["from"] + " - " + day["to"]
  end

  def discard_button(market)
    if params[:action] == "edit"
      link_to content_tag(:i, " Discard", :class => "fa fa-undo", :title => "Discard", rel: 'tooltip'), market, 
                    :class=>  "btn btn-default", 
                    :id=>"discard" 
    end
  end
end