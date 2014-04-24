module MarketsHelper
  def full_description(market)
    div_for market, class: "market-full-description" do
      render market.decorate, :image_size => "800"
    end
  end

  def tooltip(market)
    div_for market, class: "market-tooltip" do
      render :partial => 'markets/market',
             :formats => [:html], 
             :locals => {:market => market.decorate, :image_size => "180"}
    end
  end

  def market_list(markets, layout) 
    if layout == "gallery"
      render partial: "markets/shared/gallery", locals: {markets: markets } 
    else
      render partial: "markets/shared/slugs", locals: {markets: markets }
    end
  end

  def market_form(user, market)
    if user.allowed_market_creation? 
      render partial: "markets/shared/form", locals: {user: user, market: market.decorate }
    else
      message = "You have to wait one month to create another market"
      render partial: "markets/shared/error", locals: { message: message }
    end
  end

  def edit_market_form(user, market)
    render partial: "markets/shared/form", locals: {user: user, market: market.decorate }
  end

  def search_box
    render partial: "markets/shared/search"
  end

  def likes(market, &block)
    market.favorited.collect{|user| concat(user.email + " ")}
    yield if block_given?
  end
end