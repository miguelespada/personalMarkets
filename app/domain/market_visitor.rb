class MarketVisitor < Struct.new(:user)

  def email
    (user && user.email) || "guest"
  end

  def owns market
    (user && user.owns(market)) || false
  end

end