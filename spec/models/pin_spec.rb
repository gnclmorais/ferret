require 'rails_helper'

RSpec.describe Pin, type: :model do
  it 'has a valid factory' do
    expect(build(:pin)).to be_valid
  end

  it 'pin requires a place' do
    pin = build(:pin, place: nil)
    expect(pin).to_not be_valid
  end

  it 'pin requires a map' do
    pin = build(:pin, map: nil)
    expect(pin).to_not be_valid
  end
end
