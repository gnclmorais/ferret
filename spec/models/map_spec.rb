require 'rails_helper'

RSpec.describe Map, type: :model do
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
end
