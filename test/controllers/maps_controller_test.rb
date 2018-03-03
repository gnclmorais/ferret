require 'test_helper'

class MapsControllerTest < ActionDispatch::IntegrationTest
  let(user) { create(:user) }

  test '#index is successful' do
    get maps_path
    assert_response :success
  end

  test '#show is successful' do
    get map_path(create_map)
    assert_response :success
  end

  test '#new is successful' do
    get new_map_path(as: user)
    assert_response :success
  end

  test '#edit is successful' do
    get edit_map_path(create_map)
    assert_response :success
  end

  test '#create is successful' do
    assert_difference('Map.count') do
      post maps_path, params: {
        map: { name: 'Name', description: 'Description' }
      }
    end
  end

  test '#update is successful' do
    map = create_map
    patch map_path(map), params: { map: { name: 'New Name' } }
    assert_equal 'New Name', map.reload.name
  end

  test '#destroy is successful' do
    map = create_map
    delete map_path(map)
    assert_raises(ActiveRecord::RecordNotFound) { Map.find(map.id) }
  end

  private

  def create_map
    new_map = Map.new(name: 'Name', description: 'Description')
    new_map.save
    new_map
  end
end
