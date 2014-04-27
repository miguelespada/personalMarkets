class CouponsController < ApplicationController
  before_filter :load_market, only: [:new, :create]
  before_filter :load_coupon, only: [:buy, :show]

  def index
    authorize! :list, Coupon
    @coupons = Coupon.all
  end

  def show
  end

  def buy
    authorize! :buy_coupon, @coupon.market
    @coupon.buy!(current_user, number)
    redirect_to market_path(@coupon.market), notice: 'You has successfully bought the coupon.'
    rescue
      render :status => :unauthorized, :text => "Incorrect number of coupons." 
  end
  
  def list_transactions   
    user = User.find(params[:user_id])
    authorize! :see_transactions, user
    @out_transactions = CouponTransaction.where(:user => user)
    markets ||= Market.where(user: user)
    @in_transactions = CouponTransaction.transactions(markets)
    render "transactions"
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
end

