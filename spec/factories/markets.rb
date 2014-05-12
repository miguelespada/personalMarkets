# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :market do
    sequence(:name) { |n| "My market #{n}" }
    sequence(:description) { |n| "My market description #{n}" }
    created_at Time.now
    user
    category
    coupon

    trait :with_featured_image do
        featured
    end
  end
end
