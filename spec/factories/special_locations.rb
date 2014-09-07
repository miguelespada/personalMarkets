# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :special_location do    
    sequence(:name) { |n| "Location_#{n}" }
    latitude 0
    longitude 0
  end
end
