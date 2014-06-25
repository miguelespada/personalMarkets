class MarketProPayment < Struct.new(:market, :payment)

  def paymill_price
    payment.paymill_price
  end

  def token
    payment.token
  end

  def description
    "VIM payment for #{market.to_param}"
  end
end