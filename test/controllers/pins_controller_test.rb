require 'test_helper'

class PinsControllerTest < ActionDispatch::IntegrationTest
  test '#create sets up a new pin when a place does not exist' do
    # TODO
  end

  test '#create sets up a new pin when a place already exists' do
    # TODO
  end

  private

  def create_pin_for(place, map:)
    new_pin = Pin.new(place: place, map: map)
    new_pin.save
    new_pin
  end
end
