class CouponTransaction
  include Mongoid::Document
  belongs_to :user, class_name: "User", inverse_of: :coupon_transactions
  belongs_to :coupon, class_name: "Coupon", inverse_of: :coupon_transactions
  field :number, type: Integer
end
