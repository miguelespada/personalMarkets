class MapsController < ApplicationController
  def index
  	@markets = Market.all
		@geojson = @markets.collect{|market| market.to_marker}

		respond_to do |format|
        format.html 
        format.json {render json: @geojson}
    end
  end
end
