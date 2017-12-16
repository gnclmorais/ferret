require 'application_system_test_case'

class MapsTest < ApplicationSystemTestCase
  test 'showing a list of Maps' do
    map = create(:map)

    visit maps_path

    assert_text map.name
  end

  test 'creating a new Map' do
    visit maps_path

    click_link 'New map'

    assert_button 'Save map'
  end

  test 'showing a Map' do
    map = create(:map)

    visit map_path(map)

    assert_text map.name
    assert_text map.description
  end

  test 'editing the title and description of a Map' do
    map = create(:map)

    visit edit_map_path(map)
  end

  # test 'deleting a Map' do
  #   visit
  # end

  # test 'adding a new Pin to a Map' do
  #   visit
  # end

  # test 'removing a Pin from a Map' do
  #   visit
  # end
end
