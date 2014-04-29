class Coupon
  include Mongoid::Document
  belongs_to :market, class_name: "Market", inverse_of: :coupons
  has_many :transactions, class_name: "CouponTransaction", inverse_of: :coupon

  field :description, type: String
  field :price, type: Integer
  field :available, type: Integer

  def check_buy number
    raise ArgumentError, "Incorrect number of coupons" unless number > 0 && number <= available
  end

  def buy! user, number, paymill_transaction_id
    check_buy number
    transaction = CouponTransaction.new
    transaction.user = user
    transaction.coupon = self
    transaction.number = number
    transaction.paymill_transaction_id = paymill_transaction_id
    transaction.save
    self.available -= number
    self.update
  end
end
