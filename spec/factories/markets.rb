# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :market do
    sequence(:name) { |n| "My market #{n}" }
    sequence(:description) { |n| "My market description #{n}" }
    user
    category
  end
end
