class CouponsController < ApplicationController
  load_resource :only => [:show, :buy]
  authorize_resource :except => [:show, :index]
  
  def index
    @coupons = Coupon.all
  end

  def show
  end

  def buy
    CouponDomain.buy(@coupon, current_user, number)
    redirect_to market_path(@coupon.market), notice: 'You has successfully bought the coupon.'
    rescue ArgumentError
      render :status => :unauthorized, :text => "Incorrect number of coupons." 
  end
  
  def list_transactions
    @out_transactions = CouponTransaction.where(user: current_user)  
    markets ||= Market.where(user: current_user)
    @in_transactions = CouponTransaction.transactions(markets)
    render "transactions"
  end

  private
  def coupon_params
    params.require(:coupon)
  end

  def number
    params[:number].to_i 
  end 
end

