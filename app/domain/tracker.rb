module Tracker

  def self.sign_in email
    #Keen.publish_async(:sign_in, { :username => email })  
  end

  def self.market_visit market_id, visitor
    #Keen.publish_async(:market_visit, { :market_id => market_id, :who => visitor })
  end

end