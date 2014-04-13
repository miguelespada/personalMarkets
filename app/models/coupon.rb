class Coupon
  include Mongoid::Document
  belongs_to :market, class_name: "Market", inverse_of: :coupons

  field :description, type: String
  field :price, type: Integer
  field :number, type: Integer
end
