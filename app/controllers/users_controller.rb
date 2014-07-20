class UsersController < ApplicationController
  load_resource :only => [:show, :destroy]
  authorize_resource :only => [:index, :show, :destroy]  
 
  def index
    @users = UsersPresenter.for User.all
  end
  
  def show
    render "subscription_plans"
    rescue => each 
      redirect_to action: 'index'
  end

  def like
    @user = current_user
    market = Market.find(params[:market_id])
    authorize! :like, market
    @user.like(market)
    market.like(@user)
    redirect_to :back
  end

  def unlike
    @user = current_user
    market = Market.find(params[:market_id])
    authorize! :like, market
    @user.unlike(market)
    market.unlike(@user)
    redirect_to :back
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "User successfully deleted."
    else
      redirect_to users_path, error: "Cannot delete user."
    end
  end

  def subscription
    payment = Payment.new ENV['PREMIUM_PRICE'].to_f, 1
    @subscription_payment = SubscriptionPayment.new payment
    render "subscription_payment_form"
  end

  def admin
    authorize! :admin, Market
    render "users/dashboards/admin_panel"
  end

  def user_dashboard
    render "users/dashboards/user_panel"
  end
end
