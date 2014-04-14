class CouponsController < ApplicationController
  before_filter :load_market, only: [:new, :create]
  before_filter :load_coupon, only: [:buy, :show]

  def index
    raise if current_user == nil 
    authorize! :list, CouponTransaction
      @transactions = CouponTransaction.all
    rescue CanCan::AccessDenied
        @transactions = CouponTransaction.where(user: current_user.id)
    rescue
      render :status => :unauthorized, :text => "Unauthorized action." 
  end

  def new
    authorize! :edit, @market
      @coupon = Coupon.new
    rescue CanCan::AccessDenied
      render :status => :unauthorized, :text => "Unauthorized action." 
  end

  def show
  end

  def create
    authorize! :edit, @market
    @market.create_coupon!(coupon_params)

    redirect_to coupon_path(@market.coupon), notice: 'Coupon was successfully created.'
    rescue CanCan::AccessDenied
      render :status => :unauthorized, :text => "Unauthorized action." 
    rescue
      render :status => :unauthorized, :text => "Error creating coupon." 
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

