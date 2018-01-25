FactoryBot.define do
  factory(:place) do
    name 'Happy Bones'
    sequence(:address, 1) { |n| "#{n} Example Street, New York, NY 10013, USA" }
    google_place_id 'random_google_place_id'

    trait :with_address do
      description 'Stylish, minimalist coffee shop with specialty coffee.'
    end
  end
end
