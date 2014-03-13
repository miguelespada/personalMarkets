class MapsController < ApplicationController
	def index
		@markets = Market.all
		@hash = Gmaps4rails.build_markers(@markets) do |market, marker|
  		marker.lat market.latitude
  		marker.lng market.longitude
		end
	end
end
