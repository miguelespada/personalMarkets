class Coupon
  include Mongoid::Document
  belongs_to :market, class_name: "Market", inverse_of: :coupons
  has_many :coupon_transactions, class_name: "CouponTransaction", dependent: :delete, inverse_of: :coupon

  field :description, type: String
  field :price, type: Integer
  field :available, type: Integer
end
