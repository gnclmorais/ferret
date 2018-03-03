class Map < ApplicationRecord
  has_many :pins,   dependent: :destroy
  has_many :places, through: :pins

  validates :name,        presence: true
  validates :description, presence: true
end
