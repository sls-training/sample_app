FactoryBot.define do
  factory :user do
    name { 'Example User' }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }

    trait :michael do
      name { 'Michael Example' }
      email { 'michael@example.com' }
      password { 'password' }
      password_confirmation { 'password' }
    end
  end
end
