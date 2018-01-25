require 'test_helper'

class PinsControllerTest < ActionDispatch::IntegrationTest
  test '#create sets up a new pin when a place already exists' do
    map = create(:map)
    place = create(:place)

    assert_difference 'Pin.count' do
      assert_no_difference 'Place.count' do
        post pins_path, params: {
          map: map.id, place: {
            name: place.name,
            address: place.address,
            place_id: place.google_place_id
          },
          format: :json
        }
      end
    end

    assert_response :success
  end

  test '#create sets up a new pin when a place does not exist' do
    map = create(:map)

    assert_difference 'Pin.count' do
      assert_difference 'Place.count' do
        post pins_path, params: {
          map: map.id, place: {
            name: attributes_for(:place)[:name],
            address: attributes_for(:place)[:address],
            place_id: 'random_place_id'
          },
          format: :json
        }
      end
    end

    assert_response :success
  end

  test 'no map' do
    assert_no_difference ['Pin.count', 'Place.count'] do
      post pins_path, params: {
        map: 123,
        place: {
          name: attributes_for(:place)[:name],
          address: attributes_for(:place)[:address],
          place_id: 'random_place_id'
        },
        format: :json
      }
    end

    assert_response :not_found
  end

  test '#destroy removes a pin' do
    pin = create(:pin)

    assert_difference 'Pin.count', -1 do
      delete pin_path(pin.id), params: { format: :json }
    end

    assert_response :success
  end

  test '#destroy removes a pin and its place if no other pin exists for it' do
    pin = create(:pin)

    assert_equal 1, Place.count
    assert_difference 'Place.count', -1 do
      delete pin_path(pin.id), params: { format: :json }
    end

    assert_response :success
  end
end
