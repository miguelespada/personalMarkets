class CouponsController < ApplicationController
  before_filter :load_market, only: [:new, :create]
  before_filter :load_coupon, only: [:buy, :show]
  before_filter :load_user, only: [:in_transactions, :out_transactions]

  def index
    authorize! :list, Coupon
      
    @coupons = Coupon.all
    rescue CanCan::AccessDenied
      render :status => :unauthorized, :text => "Unauthorized action." 
  end

  def show
  end


  def buy
    authorize! :buy_coupon, @coupon.market
    @coupon.buy!(current_user, number)
    redirect_to market_path(@coupon.market), notice: 'You has successfully bought the coupon.'
    rescue CanCan::AccessDenied
      render :status => :unauthorized, :text => "Unauthorized action." 
    rescue
      render :status => :unauthorized, :text => "Incorrect number of coupons." 
  end
  
  def out_transactions   
    authorize! :see_transactions, @user
      @transactions = CouponTransaction.where(:user => @user)
      render "transactions"
    rescue CanCan::AccessDenied
     render :status => :unauthorized, :text => "Unauthorized action" 
  end

  def in_transactions
    authorize! :see_transactions, @user
    markets ||= Market.where(user: @user)
    @transactions = CouponTransaction.transactions(markets)
    render "transactions"
    rescue CanCan::AccessDenied
     render :status => :unauthorized, :text => "Unauthorized action" 
  end

  private
  def coupon_params
    params.require(:coupon).permit(:description, :price, :available, :number)
  end

  def load_market
    @market = Market.find(params[:market_id])
  end

  def load_coupon
    @coupon = Coupon.find(params[:id])
  end

  def number
    params[:number].to_i 
  end 
  
  def load_user
    @user = User.find(params[:user_id])
  end
end

