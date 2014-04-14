class Coupon
  include Mongoid::Document
  belongs_to :market, class_name: "Market", inverse_of: :coupons
  has_many :transactions, class_name: "CouponTransaction", dependent: :delete, inverse_of: :coupon

  field :description, type: String
  field :price, type: Integer
  field :available, type: Integer

  def buy!(user, number)
    raise "Incorrect number of coupons" unless number > 0 && number <= available
    transaction = CouponTransaction.new
    transaction.user = user
    transaction.coupon = self
    transaction.number = number
    transaction.save 
    self.available -= number
    self.update
  end
end
