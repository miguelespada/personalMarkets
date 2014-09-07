class PaymillClient

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :email, type: String
  field :client_id, type: String

  def self.find_by_email email
    self.where(:email => email).first
  end

end