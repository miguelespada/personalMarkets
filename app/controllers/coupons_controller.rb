class CouponsController < ApplicationController
  before_filter :load_market, only: [:new, :create]
  before_filter :load_coupon, only: [:buy, :show]
  before_filter :load_user, only: [:index]

  def index
    @transactions = CouponTransaction.where(user: @user.id)
  end

  def new
    @coupon = Coupon.new
  end

  def show
    @market = @coupon.market
  end

  def create
    @coupon = Coupon.new(coupon_params)
    @market.coupon = @coupon
    if @coupon.save and @market.update
      redirect_to market_coupon_path(@coupon.market, @coupon), notice: 'Coupon was successfully created.'
    end
  end

  def buy
    authorize! :buy_coupon, @coupon.market
    
    @coupon.buy(current_user, number)
    redirect_to market_coupon_path(@coupon.market, @coupon), notice: 'You has successfully bought the coupon.'
    
    rescue CanCan::AccessDenied
      render :status => :unauthorized, :text => "Unauthorized action" 
    rescue
      render :status => :unauthorized, :text => "Incorrect number of coupons" 
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

  def load_user
    @user = User.find(params[:user_id])
  end

  def number
    params[:number].to_i 
  end 
end

