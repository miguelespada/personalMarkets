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

end