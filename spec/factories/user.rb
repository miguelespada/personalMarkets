FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "dummy_#{n}@gmail.com" }
    password               "password"
    password_confirmation  "password"

    trait :normal do
        after(:create) { |user| user.update_role(:normal)}
    end

    trait :moderator do
        after(:create) { |user| user.update_role(:moderator)}
    end

    trait :premium do
        after(:create) { |user| user.update_role(:premium)}
    end

    trait :admin do
        after(:create) { |user| user.update_role(:admin)}
    end

  end
end