# https://github.com/rails/rails/blob/main/activestorage/test/controllers/blob_controller_test.rb

FactoryBot.define do
  factory :book do
    sequence(:name) { |n| "Book ##{n}" }
    sequence(:order)

    trait :with_cover do
      cover {
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'resources', 'book_cover.jpg'),
          'image/jpeg'
        )
      }
    end
  end
end
