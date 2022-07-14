FactoryBot.define do
  factory :map do
    association :owner, factory: :user
    name { 'Get your caffeine fix' }
    description { 'All the best coffee shops in New York' }
  end

  trait :with_one_pin do
    after :create do |map, _evaluator|
      create :pin, map: map
    end
  end

  trait :published do
    published { true }
  end
end
