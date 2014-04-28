class CouponDomain

  def self.buy coupon, user, quantity
    PaymillWrapper.create_transaction user.email, quantity
    coupon.buy! user, quantity
  end
end