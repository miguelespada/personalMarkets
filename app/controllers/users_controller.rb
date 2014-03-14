class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user ||=  User.find(params[:id])
    rescue Exception => each 
      redirect_to action: 'index'
  end

  def like
    @user = User.find(params[:user_id])
    market = Market.find(params[:market_id])
    v = params[:v] == "1"
    @user.like(market, v)
    market.like(@user, v)
    render 'show'
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to action: 'index'
  end
end
