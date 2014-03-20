class MapsController < ApplicationController
  def index
    markets = Market.where(:latitude.nin => ["", nil], :longitude.nin => ["", nil])

    if markets.count > 0
      @geojson = markets.collect{|market| market.to_marker(view_context.tooltip(market))}
    end 
    @geojson ||= ""

    respond_to do |format|
      format.html 
      format.json {render json: @geojson}
    end
  end
end
