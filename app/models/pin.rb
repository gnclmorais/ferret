class Pin < ApplicationRecord
  belongs_to :place
  belongs_to :map

  validates :place, presence: true
  validates :map,   presence: true
  validates_uniqueness_of :place_id, scope: :map_id
end
