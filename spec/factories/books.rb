# https://apidock.com/rails/ActionDispatch/TestProcess/fixture_file_upload
include ActionDispatch::TestProcess

FactoryBot.define do
  factory :book do
    sequence(:name) { |n| "Book ##{n}" }
    sequence(:order)

    trait :with_cover do
      cover {
        fixture_file_upload(
          Rails.root.join('spec', 'resources', 'book_cover.jpg')
        )
      }
    end
  end
end
