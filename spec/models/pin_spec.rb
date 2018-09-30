require 'rails_helper'

RSpec.describe Pin, type: :model do
  it 'has a valid factory' do
    expect(build(:pin)).to be_valid
  end

  it { should belong_to(:place) }
  it { should belong_to(:map) }
  it { should have_many(:tagged_pins) }

  describe 'has many' do
    it 'tags through tagged pins' do
      pin = create(:pin)
      expect(pin.tags).to be_empty

      pin.tags << create(:tag)
      expect(pin.tags).not_to be_empty
    end
  end

  describe 'destroy' do
    it 'removes any associated tagged_pins' do
      pin = create(:pin)
      create(:tagged_pin, pin: pin)

      expect { pin.destroy }.to change { TaggedPin.count }.from(1).to(0)
    end

    it 'removes any associated place if no other pin links to it' do
      place = create(:place)
      pinOne = create(:pin, place: place)
      pinTwo = create(:pin, place: place)

      expect { pinOne.destroy }.not_to change { Place.count }
      expect { pinTwo.destroy }.to change { Place.count }.from(1).to(0)
    end
  end
end
