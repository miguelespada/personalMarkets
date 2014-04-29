class CouponDomain

  def self.buy coupon, user, quantity, buy_params
    coupon.check_buy quantity
    paymill_price = quantity * coupon.price * 100
    transaction = PaymillWrapper.create_transaction user.email, paymill_price, buy_params
    coupon.buy! user, quantity, transaction.id
  rescue Exception => e
    p e.backtrace
    raise CouponDomainException.new e.message
  end

end

class CouponDomainException < Exception
end
