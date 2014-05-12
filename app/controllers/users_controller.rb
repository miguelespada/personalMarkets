class UsersController < ApplicationController
  load_resource :only => [:show, :list_coupons, :destroy]
  authorize_resource :only => [:index, :show, :destroy]  
 
  def index
    @users = UsersPresenter.for User.all
  end
  
  def show
    rescue  => each 
      redirect_to action: 'index'
  end

  def like
    @user = current_user
    market = Market.find(params[:market_id])
    authorize! :like, market
    @user.like(market)
    market.like(@user)
    redirect_to user_likes_path(@user)
  end

  def unlike
    @user = current_user
    market = Market.find(params[:market_id])
    authorize! :like, market
    @user.unlike(market)
    market.unlike(@user)
    redirect_to published_markets_path
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "User successfully deleted."
    else
      redirect_to users_path, error: "Cannot delete user."
    end
  end

  def subscription
  end
end
