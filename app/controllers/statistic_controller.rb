class StatisticController < ApplicationController

  def market
    @market = Market.find(params[:market_id])
    authorize! :statistics, @market
  end

  def user
    user = User.find params[:user_id]
    authorize! :statistics, @user
    @markets = user.markets.order_by(:created_at.desc).page(params[:page]).per(4)
    render "markets"
  end

  def admin
    authorize! :manage, :all
    @markets = Market.all.order_by(:created_at.desc).page(params[:page]).per(4)
    render "markets"
  end

end

