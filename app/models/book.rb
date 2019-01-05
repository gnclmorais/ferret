class Book < ApplicationRecord
  validates :name,  presence: true
  validates :order, presence: true

  has_many :book_maps
  has_many :maps, through: :book_maps
end
