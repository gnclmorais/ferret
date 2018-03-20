require 'rails_helper'

RSpec.describe TaggedPin, type: :model do
  it { should belong_to(:tag) }
  it { should belong_to(:pin) }

  it 'should require a tag' do
    expect(build(:tagged_pin, tag: nil)).to_not be_valid
  end

  it 'should require a pin' do
    expect(build(:tagged_pin, pin: nil)).to_not be_valid
  end
end
