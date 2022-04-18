FactoryBot.define do
  factory :post_by_user, class: 'Micropost' do
    content { 'Posted by User' }
    created_at { Time.zone.now }
    user
  end

  factory :post_by_archer, class: 'Micropost' do
    content { 'Posted by Archer' }
    created_at { Time.zone.now }
    user factory: :archer
  end

  factory :post_by_lana, class: 'Micropost' do
    content { 'Posted by Lana' }
    created_at { Time.zone.now }
    user factory: :lana
  end
end
