require 'application_system_test_case'

class PinsTest < ApplicationSystemTestCase
  test 'adding a new Pin to a Map' do
    map = create(:map)

    visit edit_map_path(map, as: map.owner)
    assert has_content? 'No places in the map'

    fill_in 'Search', with: 'happy bones nyc'
    find(:css, 'button[title="Add place"]').click

    within '#places-panel' do
      assert_no_text 'No places in the map'
      assert has_content? 'Happy Bones'
    end
  end

  test 'removing a Pin from a Map' do
    map = create(:map)
    pin = create(:pin, map: map)

    visit edit_map_path(map, as: map.owner)

    within '#places-panel' do
      assert_no_text 'No places in the map'
      assert has_content? pin.name

      click_button 'Remove'

      assert has_content? 'No places in the map'
      assert_no_text pin.name
    end
  end
end
