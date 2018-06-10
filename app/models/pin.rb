class Pin < ApplicationRecord
  before_validation :ensure_name, on: :create

  belongs_to :place
  belongs_to :map
  acts_as_list scope: :map
  has_many :tagged_pins
  has_many :tags, through: :tagged_pins

  validates :place, presence: true
  validates :map,   presence: true
  validates :name,  presence: true
  validates_uniqueness_of :place_id, scope: :map_id

  def attributes
    super.merge(place: place).merge(tagged_pins: tagged_pins)
  end

  def ensure_name
    self.name ||= self.place.name

    binding.pry if self.name.nil?
  end
end
