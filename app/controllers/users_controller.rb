class UsersController < ApplicationController
  before_filter :load_user, only: [:like, :unlike, :transactions]

  def index
    @users = User.all
  end
  
  def show
    @user ||=  User.find(params[:id])
  rescue Exception => each 
    redirect_to action: 'index'
  end

  def like
    market = Market.find(params[:market_id])
    @user.like(market)
    market.like(@user)
    render 'show'
  end

  def unlike
    market = Market.find(params[:market_id])
    @user.unlike(market)
    market.unlike(@user)
    render 'show'
  end

  def transactions    
    authorize! :see_transactions, @user
      @transactions = CouponTransaction.where(:user => @user)
    rescue CanCan::AccessDenied
     render :status => :unauthorized, :text => "Unauthorized action" 
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to action: 'index'
  end

  private 
    def load_user
      @user = User.find(params[:user_id])
    end
end
