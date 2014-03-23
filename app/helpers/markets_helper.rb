module MarketsHelper
  def full_description(market)
    div_for market, class: "market-full-description" do
      render market.decorate, :image_size => "500"
    end
  end

  def gallery_item(market)
    div_for market, class: "market-gallery-item" do
      render market.decorate, :image_size => "180"
    end
  end

  def slug_item(market)
    div_for market, class: "market-slug" do
      render market.decorate, :image_size => "50"
    end
  end

  def tooltip(market)
    div_for market, class: "market-tooltip" do
      render :partial => 'markets/market',
             :formats => [:html], 
             :locals => {:market => market.decorate, :image_size => "180"}
    end
  end

  def market_list(markets, layout, &block) 
      if layout == "slugs"
        markets.collect{|market| concat(slug_item(market))}
      else
        markets.collect{|market| concat(gallery_item(market))}
      end
      yield if block_given?
  end

  def market_form(user, market)
    render partial: "markets/shared/form", locals: {user: user, market: market}
  end

  def search_box
    render partial: "markets/shared/search"
  end

  def likes(market, &block)
    market.favorited.collect{|user| concat(user.email + " ")}
    yield if block_given?
  end
end