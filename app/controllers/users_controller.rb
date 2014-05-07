class UsersController < ApplicationController
  load_resource :only => [:show, :list_coupons, :destroy]
  authorize_resource :only => [:index, :show, :destroy, :list_coupons]  
 
  def index
    @users = UsersPresenter.for User.all
  end
  
  def show
    rescue  => each 
      redirect_to action: 'index'
  end

  def list_coupons
    @coupons = @user.markets.collect{|market| market.coupon if market.coupon.present?}
  end

  def like
    market = Market.find(params[:market_id])
    authorize! :like, market
    current_user.like(market)
    market.like(current_user)
    redirect_to user_likes_path(current_user)
  end

  def unlike
    market = Market.find(params[:market_id])
    authorize! :unlike, market
    current_user.unlike(market)
    market.unlike(current_user)
    redirect_to user_likes_path(current_user)
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
