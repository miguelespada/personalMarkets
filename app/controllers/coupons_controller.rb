class CouponsController < ApplicationController
  before_filter :load_market, only: [:new, :create]
  before_filter :load_coupon, only: [:buy, :show]

  def index
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
    number = params[:available].to_i 
    if @coupon.available >= number
      @coupon.available -= number
      if @coupon.update
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
end

