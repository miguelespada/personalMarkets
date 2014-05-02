class UsersController < ApplicationController
  authorize_resource :only => [:index, :show, :destroy, :likes, :like, :unlike]  
  load_resource :only => [:profile]

  def index
    @users = UsersPresenter.for User.all
  end
  
  def show
    @user ||=  User.find(user_id)
    rescue Exception => each 
      redirect_to action: 'index'
  end

  def like
    market = Market.find(params[:market_id])
    current_user.like(market)
    market.like(current_user)
    redirect_to user_likes_path(current_user)
  end

  def unlike
    market = Market.find(params[:market_id])
    current_user.unlike(market)
    market.unlike(current_user)
    redirect_to user_likes_path(current_user)
  end

  def destroy
    @user = User.find(user_id)
    @user.destroy
    redirect_to action: 'index'
  end

  def subscription
  end
end
