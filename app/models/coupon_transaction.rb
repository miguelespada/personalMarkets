class CouponTransaction
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  belongs_to :user, class_name: "User", inverse_of: :coupon_transactions
  belongs_to :coupon, class_name: "Coupon", inverse_of: :transactions
  field :number, type: Integer
  field :paymill_transaction_id, type: String
  field :client_token, type: String

  def self.transactions(markets)
    transactions = []
    markets.each do |m|
      if m.has_coupon?
        transactions += CouponTransaction.where(coupon: m.coupon)
      end
    end 
    transactions 
  end

  def value
    number * coupon.price
  end

  def paid
    (self.value * 1.1) + 0.25
  end

  def after_paymill
    (self.paid - 0.28) - (self.paid * 0.0295)
  end
end
