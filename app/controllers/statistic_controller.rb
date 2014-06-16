class StatisticController < ApplicationController

  def market
    @market = Market.find(params[:market_id])
  end

  def user
    user = User.find params[:user_id]
    @markets = user.markets.order_by(:created_at.desc).page(params[:page]).per(4)
  end

  def admin
  	@markets = Market.all.order_by(:created_at.desc).page(params[:page]).per(4)
  end

end

