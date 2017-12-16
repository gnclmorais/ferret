require 'test_helper'

class MapTest < ActiveSupport::TestCase
  test 'has a valid factory' do
    assert_valid? build(:map)
  end

  test 'map requires a name that is long enough' do
    map = Map.new(name: 'A', description: 'Description')
    refute map.valid?
  end

  test 'map requires a description' do
    map = Map.new(name: 'Name', description: nil)
    refute map.valid?
  end
end
