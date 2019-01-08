require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should have_many(:maps) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:order) }

  it 'has a valid factory' do
    expect(build(:book)).to be_valid
  end
end
