class MapsController < ApplicationController
  def index
    @geojson = generate_geojson(Market.with_location) || ""

    respond_to do |format|
      format.html 
      format.json {render json: @geojson}
    end
  end
  private 
  def generate_geojson(markets)
    if markets.count > 0
      markets.collect{|market| market.to_marker(view_context.tooltip(market))}
    end
  end
end
