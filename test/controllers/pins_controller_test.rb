require 'test_helper'

class PinsControllerTest < ActionDispatch::IntegrationTest
  test '#create sets up a new pin when a place already exists' do
    map = create(:map)
    place = create(:place)

    assert_difference 'Pin.count' do
      assert_no_difference 'Place.count' do
        post pins_path, params: {
          map: map.id, place: {
            id: place.id,
            name: place.name,
            address: place.address
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
            id: 123,
            lace_id: 'random_place_id',
            name: attributes_for(:place)[:name],
            address: attributes_for(:place)[:address]
          },
          format: :json
        }
      end
    end

    assert_response :success
  end
end
