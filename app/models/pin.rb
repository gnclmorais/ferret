class Pin < ApplicationRecord
  belongs_to :place
  belongs_to :map
  acts_as_list scope: :map
  has_many :tagged_pins
  has_many :tags, through: :tagged_pins

  delegate :name, to: :place

  validates :place, presence: true
  validates :map,   presence: true
  validates_uniqueness_of :place_id, scope: :map_id

  def attributes
    super.merge(place: place).merge(tags: tags)
  end
end
