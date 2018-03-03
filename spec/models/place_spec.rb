require 'rails_helper'

RSpec.describe Place, type: :model do
  it 'has a valid factory' do
    expect(build(:place)).to be_valid
  end

  it 'requires a name' do
    place = build(:place, name: nil)
    expect(place).to_not be_valid
  end

  it 'requires an address' do
    place = build(:place, address: nil)
    expect(place).to_not be_valid
  end

  it 'requires a Google plage_id' do
    place = build(:place, google_place_id: nil)
    expect(place).to_not be_valid
  end

  it 'does not requires a description' do
    place = build(:place, description: nil)
    expect(place).to be_valid
  end
end
