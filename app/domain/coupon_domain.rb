class CouponDomain

  def self.buy user, coupon_payment
    coupon_payment.check_buy
    transaction = PaymillWrapper.create_transaction user.email, coupon_payment
    coupon_payment.buy! user, transaction.id
  rescue  => e
    raise CouponDomainException.new e.message
  end

end

class CouponDomainException < Exception
end
