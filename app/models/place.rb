class Place < ApplicationRecord
  has_many :pins
  has_many :maps, through: :pins

  validates :name,    presence: true
  validates :address, presence: true
end
