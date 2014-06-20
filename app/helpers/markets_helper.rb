module MarketsHelper
  def tooltip(market)
    div_for market, class: "market-tooltip" do
      render :partial => 'markets/shared/views/tooltip',
             :formats => [:html], 
             :locals => {:market => market.decorate}
    end
  end

  def save_and_publish_button(form, market)
    if market.draft?
      if params[:action] == "edit"
        form.button :submit, "Udpate Market and Publish", class: 'btn', id: 'save-and-publish-button'
        else
        form.button :submit, "Create Market and Publish", class: 'btn', id: 'save-and-publish-button'
      end
    end
  end
end