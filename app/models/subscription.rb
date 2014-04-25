class Subscription

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :name, type: String
  field :card_number, type: String
  field :expiration_month, type: String
  field :expiration_year, type: String
  field :cvc, type: String
  field :paymill_card_token, type: String

end