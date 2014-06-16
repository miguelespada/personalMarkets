class StatisticController < ApplicationController

  def market
    @market = Market.find(params[:market_id])
  end

  def user
    user = User.find params[:user_id]
    @markets = user.markets
  end

  def admin
  	@markets = Market.all
  end

end

