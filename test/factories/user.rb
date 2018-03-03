FactoryBot.define do
  factory(:user) do
    sequence(:email) { |n| "user.#{n}@bridge-u.example" }
    password 'password'
    encrypted_password 'password'
  end
end
