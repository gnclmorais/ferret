require 'test_helper'

class PinTest < ActiveSupport::TestCase
  test 'has a valid factory' do
    assert_valid? build(:pin)
  end

  test 'pin requires a place' do
    pin = build(:pin, place: nil)
    refute pin.valid?
  end

  test 'pin requires a map' do
    pin = build(:pin, map: nil)
    refute pin.valid?
  end
end
