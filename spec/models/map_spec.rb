require 'rails_helper'

RSpec.describe Map, type: :model do
  it { should belong_to(:owner) }
  it { should validate_presence_of(:owner) }

  it 'has a valid factory' do
    expect(build(:map)).to be_valid
  end

  it 'requires a title' do
    map = Map.new(name: '', description: 'Description')
    expect(map).to_not be_valid
  end

  it 'requires a description' do
    map = Map.new(name: 'Name', description: nil)
    expect(map).to_not be_valid
  end

  describe 'destroy' do
    it 'removes any associated pins' do
      map = create(:map)
      pin = create(:pin, map: map)

      expect { map.destroy }.to change { Pin.count }.from(1).to(0)
    end
  end
end
