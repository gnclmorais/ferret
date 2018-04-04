class TaggedPin < ApplicationRecord
  belongs_to :tag
  belongs_to :pin
  validates :tag_id, :pin_id, presence: true

  def as_json(options = {})
    {
      id: id,
      name: tag.name,
      tag_id: tag.id
    }
  end
end
