require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe 'has many' do
    it 'pins through tagged pins' do
      tag = create(:tag)
      expect(tag.pins).to be_empty

      tag.pins << create(:pin)
      expect(tag.pins).not_to be_empty
    end
  end
end
