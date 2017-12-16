require 'application_system_test_case'

class MapsTest < ApplicationSystemTestCase
  test 'showing a list of Maps' do
    visit maps_path
  end

  test 'creating a new Map' do
    visit maps_path

    click_link 'New map'
  end

  test 'showing a Map' do
    visit map_path(map)
  end

  test 'editing the title and description of a Map' do
    visit edit_map_path(map)
  end

  test 'deleting a Map' do
    visit
  end

  test 'adding a new Pin to a Map' do
    visit
  end

  test 'removing a Pin from a Map' do
    visit
  end
end
