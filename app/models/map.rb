class Map < ApplicationRecord
  has_many :pins
  has_many :places, through: :pins

  validates :name,        presence: true, length: { minimum: 2 }
  validates :description, presence: true
end
