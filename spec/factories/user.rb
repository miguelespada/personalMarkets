FactoryGirl.define do
  factory :user do
	  sequence(:email) { |n| "dummy_#{n}@gmail.com" }
	  password               "password"
	  password_confirmation  "password"

    trait :moderator do
        after(:create) { |user| user.add_role(:moderator)}
    end
	end
end