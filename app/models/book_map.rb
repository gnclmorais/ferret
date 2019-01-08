class BookMap < ApplicationRecord
  belongs_to :book
  belongs_to :map
  validates :book_id, :map_id, presence: true
end
