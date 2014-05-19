class Subscription

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :email, type: String
  field :paymill_id, type: String

end