class CouponsController < ApplicationController
  before_filter :load_market
  before_filter :load_coupon, only: [:show]

  def index
  end

  def new
    @coupon = Coupon.new
  end

  def show
  end

  def create
    @coupon = @market.coupons.new(coupon_params)
    @market.numner_of_coupons = params[:number] 
    if @coupon.save and @market.update
      redirect_to market_coupon_path(@market, @coupon), notice: 'Coupon was successfully created.'
    end
  end
  
  private
  def coupon_params
    params.require(:coupon).permit(:description, :price, :number)
  end

  def load_market
    @market = Market.find(params[:market_id])
  end

  def load_coupon
    @coupon = Coupon.find(params[:id])
  end
end

