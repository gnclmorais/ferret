FactoryBot.define do
  factory(:place) do
    name 'Happy Bones'
    description 'Stylish, minimalist coffee shop with specialty coffee.'
    sequence(:address, 1) { |n| "#{n} Example Street, New York, NY 10013, USA" }
  end
end
