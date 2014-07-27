class CouponsController < ApplicationController
  load_resource :only => [:buy_coupon_form, :buy, :coupon_payment]
  authorize_resource :except => [:buy_coupon_form, :bought_coupons_by_user, :sold_coupons_by_market, :gallery, :localizador]
  
  def index
    @coupons = Coupon.all
  end

  def gallery
    @coupons = Coupon.all.collect{|coupon| coupon if coupon.active?}.compact.uniq
    @coupons = Kaminari.paginate_array(@coupons).page(params[:page]).per(6)
  end

  def coupon_payment
    payment = Payment.new @coupon.price, number
    @coupon_payment = CouponPayment.new @coupon, payment
  end
  
  def buy_coupon_form
  end

  def buy
    payment = Payment.for payment_params
    coupon_payment = CouponPayment.new @coupon, payment

    CouponDomain.buy current_user, coupon_payment
    redirect_to bought_coupons_by_user_path(current_user), notice: 'You has successfully bought the coupon.'
    rescue CouponDomainException => e
      p e.message
      render :status => :unauthorized, :text => "Error buying coupons #{e.message}." 
  end
  
  def bought_coupons_by_user
    user = User.find(params[:user_id])
    authorize! :list_user_transactions, user
    @transactions = CouponTransaction.where(user: user) 
    render "coupons/transactions/bought_coupons_by_user"
  end

  def sold_coupons_by_market
    market = Market.find(params[:market_id])
    authorize! :list_market_transactions, market
    @transactions = market.coupon.transactions
    render "coupons/transactions/sold_coupons_by_market"
  end

  def localizador
    @transaction = CouponTransaction.find(params[:transaction_id])
    authorize! :see_localizador, @transaction
    render  "coupons/transactions/localizador"
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

