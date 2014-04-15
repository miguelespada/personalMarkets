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
    @user.like(market)
    market.like(@user)
    render 'show'
  end

  def unlike
    @user = User.find(params[:user_id])
    market = Market.find(params[:market_id])
    @user.unlike(market)
    market.unlike(@user)
    render 'show'
  end

  def transactions
    @transactions = CouponTransaction.where(user: current_user.id)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to action: 'index'
  end
end
