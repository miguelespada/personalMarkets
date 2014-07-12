class CouponTransaction
  include Mongoid::Document
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
end
