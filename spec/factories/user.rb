FactoryGirl.define do
  factory :user do
	  sequence(:email) { |n| "dummy_#{n}@gmail.com" }
	  password               "password"
	  password_confirmation  "password"
	end
end