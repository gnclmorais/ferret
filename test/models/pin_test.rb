require 'test_helper'

class PinTest < ActiveSupport::TestCase
  setup do
    @map = Map.new(name: 'The Best', description: 'The best of the best.')
    @place = Place.new(name: 'Dao', description: 'Coffee!', address: 'The Mall')
  end

  test 'pin requires a place' do
    pin = Pin.new(map: @map)
    refute pin.valid?
  end

  test 'pin requires a map' do
    pin = Pin.new(place: @place)
    refute pin.valid?
  end
end
