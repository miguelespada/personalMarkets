class CouponDomain

  def self.buy coupon, user, quantity, token
    coupon.check_buy quantity
    transaction = PaymillWrapper.create_transaction user.email, quantity, token
    coupon.buy! user, quantity, transaction.id
  end

end