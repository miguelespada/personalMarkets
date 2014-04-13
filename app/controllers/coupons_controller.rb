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
    number = params[:coupon][:available].to_i 
    if @coupon.available >= number
      @coupon.available -= number
      transaction = CouponTransaction.new
      transaction.user = current_user
      transaction.coupon = @coupon
      transaction.number = number

      if transaction.save and @coupon.update
        redirect_to market_coupon_path(@coupon.market, @coupon), notice: 'You has successfully bought the coupon.'
      end
    end
  end

  private
  def coupon_params
    params.require(:coupon).permit(:description, :price, :available)
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
end

