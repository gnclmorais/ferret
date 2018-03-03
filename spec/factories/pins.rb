FactoryBot.define do
  factory :pin do
    association :place
    association :map
  end
end
