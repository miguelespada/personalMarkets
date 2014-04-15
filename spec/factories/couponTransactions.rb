FactoryGirl.define do
  factory :couponTransaction do
    number 1
    user
    coupon
  end
end