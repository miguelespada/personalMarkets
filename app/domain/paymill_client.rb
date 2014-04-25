class PaymillClient

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :email, type: String
  field :client_id, type: String

end