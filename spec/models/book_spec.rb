require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should have_many(:maps) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:order) }

  it 'has a valid factory' do
    expect(build(:book)).to be_valid
  end

  it 'accepts a cover' do
    book_without_cover = create(:book)
    expect(book_without_cover.cover).to_not be_attached

    book_with_cover = create(:book, :with_cover)
    expect(book_with_cover.cover).to be_attached
  end
end
