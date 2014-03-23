class StaticPagesController < ApplicationController
  def home
  end
  def search
  end
  def calendar
    @markets = Market.search("", "", "01/01/2014", "")
  end
  def map
    @geojson = generate_geojson(Market.with_location) || ""
    respond_to do |format|
      format.html 
      format.json {render json: @geojson}
    end
  end

  private 
  
  def generate_geojson(markets)
    markets.collect{|market| market.to_marker(view_context.tooltip(market))} if markets.count > 0
  end
end
