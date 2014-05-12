class StatisticController < ApplicationController

  def market
    @market = Market.find(params[:market_id])
  end

end

