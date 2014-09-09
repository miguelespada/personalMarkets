class Subscription

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :email, type: String
  field :paymill_id, type: String

  def self.has_a_paid_subscription? user
    where(email: user.email).exists? 
  end

end