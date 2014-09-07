# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do    
    sequence(:name) { |n| "Dummy_tag_#{n}" }
  end

end
