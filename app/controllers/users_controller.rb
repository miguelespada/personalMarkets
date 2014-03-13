class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user ||=  User.find(params[:id])
    rescue Exception => each 
      redirect_to action: 'index'
  end

  def favorite
    @user = User.find(params[:user_id])
    market = Market.find(params[:market_id])
    @user.favorites << market
    market.favorited << @user
    @user.save!
    market.save!
    render 'show'
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to action: 'index'
  end
end
