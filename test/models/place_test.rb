require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  test 'has a valid factory' do
    assert_valid? build(:place)
  end

  test 'place requires a name' do
    place = build(:place, name: nil)
    refute place.valid?
  end

  test 'place requires an address' do
    place = build(:place, address: nil)
    refute place.valid?
  end

  test 'place requires a Google plage_id' do
    place = build(:place, google_place_id: nil)
    refute place.valid?
  end

  test 'place does not requires a description' do
    place = build(:place, description: nil)
    assert place.valid?
  end
end
