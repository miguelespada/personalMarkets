class MapsController < ApplicationController
	def index
		@markets = Market.all
		@hash = Gmaps4rails.build_markers(@markets) do |market, marker|
  		marker.lat market.latitude
  		marker.lng market.longitude
  		marker.infowindow render_to_string(:partial => "/markets/shared/tooltip", :locals => { :market => market})
		end
	end
end
