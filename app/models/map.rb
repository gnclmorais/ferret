class Map < ApplicationRecord
  belongs_to :owner, class_name: :User

  has_many :pins,   dependent: :destroy
  has_many :places, through: :pins

  validates :owner,       presence: true
  validates :name,        presence: true
  validates :description, presence: true
end
