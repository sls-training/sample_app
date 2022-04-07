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

  factory :admin, class: 'User' do
    name { 'Admin User' }
    sequence(:email) { |n| "admin_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }
  end

  factory :many_user, class: 'User' do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "manyuser_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
