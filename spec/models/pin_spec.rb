require 'rails_helper'

RSpec.describe Pin, type: :model do
  it 'has a valid factory' do
    expect(build(:pin)).to be_valid
  end

  it { should belong_to(:place) }
  it { should belong_to(:map) }

  describe 'has many' do
    it 'tags through tagged pins' do
      pin = create(:pin)
      expect(pin.tags).to be_empty

      pin.tags << create(:tag)
      expect(pin.tags).not_to be_empty
    end
  end
end
