class SubscriptionOffer
  @@offer
  def self.offer= offer
    @@offer = offer
  end
  def self.offer
    @@offer
  end
end