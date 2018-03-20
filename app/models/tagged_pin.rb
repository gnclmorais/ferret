class TaggedPin < ApplicationRecord
  belongs_to :tag
  belongs_to :pin
  validates :tag_id, :pin_id, presence: true
end