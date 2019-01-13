class Map < ApplicationRecord
  belongs_to :owner, class_name: :User

  has_many :pins, -> { order(position: :asc) }, dependent: :destroy
  has_many :places, through: :pins

  has_one :book_map
  has_one :book, through: :book_map
  has_one_attached :cover

  validates :owner,       presence: true
  validates :name,        presence: true
  validates :description, presence: true

  scope :with_tagged_places, -> { includes(pins: [:place, :tags]) }
end
