FactoryBot.define do
  factory :book do
    sequence(:name) { |n| "Book ##{n}" }
    sequence(:order)
  end
end
