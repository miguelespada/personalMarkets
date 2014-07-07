class CouponsController < ApplicationController
  load_resource :only => [:show, :buy, :coupon_payment]
  authorize_resource :except => [:show, :bought_coupons_by_user, :sold_coupons_by_market, :gallery]
  
  def index
    @coupons = Coupon.all
  end

  def show
  end

  def gallery
    @coupons = Coupon.all.page(params[:page]).per(6)
    render :layout => !request.xhr?
  end

  def coupon_payment
    payment = Payment.new @coupon.price, number
    @coupon_payment = CouponPayment.new @coupon, payment
  end

  def buy
    payment = Payment.for payment_params
    coupon_payment = CouponPayment.new @coupon, payment

    CouponDomain.buy current_user, coupon_payment
    redirect_to market_path(@coupon.market), notice: 'You has successfully bought the coupon.'
    rescue CouponDomainException => e
      p e.message
      render :status => :unauthorized, :text => "Incorrect number of coupons #{e.message}." 
  end
  
  def bought_coupons_by_user
    user = User.find(params[:user_id])
    authorize! :list_user_transactions, user
    @transactions = CouponTransaction.where(user: user) 
  end

  def sold_coupons_by_market
    market = Market.find(params[:market_id])
    authorize! :list_market_transactions, market
    @transactions = market.coupon.transactions
  end

  private

  def payment_params
    {
      name: params['name'],
      price: params['price'].to_f,
      quantity: params[:quantity].to_i,
      token: params['paymill_card_token']
    }
  end

  def buy_params
    buy_params = {
      :name => params[:name],
      :token => params[:paymill_card_token]
    }
  end

  def coupon_params
    params.require(:coupon).permit(photography_attributes: [:photo])
  end

  def number
    params[:number].to_i 
  end 

  def quantity
    params[:quantity].to_i
  end
end

