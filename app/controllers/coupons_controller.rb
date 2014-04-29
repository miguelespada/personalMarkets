class CouponsController < ApplicationController
  load_resource :only => [:show, :buy, :coupon_payment]
  authorize_resource :except => [:show, :index]
  
  def index
    @coupons = Coupon.all
  end

  def show
  end

  CouponPayment = Struct.new(:coupon, :total_price, :quantity)

  def coupon_payment
    total_price = number * @coupon.price * 100
    @coupon_payment = CouponPayment.new @coupon, total_price, number
  end

  def buy
    CouponDomain.buy @coupon, current_user, quantity, buy_params
    redirect_to market_path(@coupon.market), notice: 'You has successfully bought the coupon.'
    rescue CouponDomainException => e
      render :status => :unauthorized, :text => "Incorrect number of coupons #{e.message}." 
  end
  
  def list_transactions
    @out_transactions = CouponTransaction.where(user: current_user)  
    markets ||= Market.where(user: current_user)
    @in_transactions = CouponTransaction.transactions(markets)
    render "transactions"
  end

  private

  def buy_params
    buy_params = {
      :name => params[:name],
      :token => params[:paymill_card_token]
    }
  end

  def coupon_params
    params.require(:coupon)
  end

  def number
    params[:number].to_i 
  end 

  def quantity
    params[:quantity].to_i
  end
end

