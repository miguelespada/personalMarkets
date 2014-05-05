class MarketsRepo

  def self.initialize_market
    Market.new(coupon: Coupon.new)
  end

  def self.find params
    Market.find params
  end

  def self.user_markets user
    Market.find_all user
  end

  # def self.published_markets
  #   Market.where(state: :published)
  # end

end