require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  test 'has a valid factory' do
    assert_valid? build(:place)
  end

  test 'place requires a name' do
    place = Place.new(address: 'Main Street', description: 'Best. Place. Ever.')
    refute place.valid?
  end

  test 'place requires an address' do
    place = Place.new(name: 'Paradise', description: 'Best. Place. Ever.')
    refute place.valid?
  end

  test 'place requires a description' do
    place = Place.new(name: 'Paradise', address: 'Main Street')
    refute place.valid?
  end
end
