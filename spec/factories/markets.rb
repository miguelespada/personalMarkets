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
        featured {{ public_id: "sxmltfqlramr1arsaaay", version: "1396518223", width: 259, height: 194, format: "jpg", resource_type: "image" }}
    end
  end
end
