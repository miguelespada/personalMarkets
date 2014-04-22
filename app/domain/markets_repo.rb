class MarketsRepo

  def self.find params
    Market.find params
  end

  def self.user_markets user
    Market.find_all user
  end

end