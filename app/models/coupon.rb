class Coupon
  include Mongoid::Document
  belongs_to :market, class_name: "Market", inverse_of: :coupons
  has_many :transactions, class_name: "CouponTransaction", inverse_of: :coupon

  field :description, type: String
  field :price, type: Integer
  field :available, type: Integer
  has_attachment :photo, accept: [:jpg, :png, :gif]


  def buy!(user, number)
    raise ArgumentError, "Incorrect number of coupons" unless number > 0 && number <= available
    transaction = CouponTransaction.new
    transaction.user = user
    transaction.coupon = self
    transaction.number = number
    transaction.save 
    self.available -= number
    self.update
  end
end
