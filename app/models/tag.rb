class Tag < ApplicationRecord
  has_many :tagged_pins
  has_many :pins, through: :tagged_pins

  validates :name, presence: true
  validates_uniqueness_of :name

  def attributes
    {
      id: id,
      name: name
    }
  end
end
