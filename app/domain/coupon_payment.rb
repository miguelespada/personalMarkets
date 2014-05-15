class CouponPayment < Struct.new(:coupon, :payment)

  def check_buy
    coupon.check_buy payment.quantity
  end

  def quantity
    payment.quantity
  end

  def buy! user, transaction_id
    coupon.buy! user, quantity, transaction_id
  end

  def description
    "Coupon payment for #{coupon.id}"
  end

  def token
    payment.token
  end

  def paymill_price
    payment.paymill_price
  end

end