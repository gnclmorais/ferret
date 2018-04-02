require 'application_system_test_case'

class MapsTest < ApplicationSystemTestCase
  test 'showing a list of Maps' do
    map = create(:map)

    visit maps_path

    assert has_content? map.name
  end

  test 'creating a new Map' do
    visit maps_path(as: create(:user))

    click_link 'New map'
    fill_in 'Name', with: 'Cheesy Delight'
    fill_in 'Description', with: 'The best pizza in New York'
    click_button 'Save map'

    assert_field 'Name', text: 'Cheesy Delight'
    assert_field 'Description', text: 'The best pizza in New York'

    assert_button 'Save map'
    assert_link 'Preview'
    assert_link 'Delete'
  end

  test 'showing a Map' do
    map = create(:map)

    visit map_path(map)

    assert has_content? map.name
    assert has_content? map.description
  end

  test 'editing the title and description of a Map' do
    map = create(:map, name: 'Old name', description: 'Old description')

    visit edit_map_path(map, as: map.owner)
    assert_field 'Name', text: 'Old name'
    assert_field 'Description', text: 'Old description'

    fill_in 'Name', with: 'New name'
    fill_in 'Description', with: 'New description'
    click_button 'Save map'

    assert_text 'New name'
    assert_text 'New description'
  end

  test 'deleting a Map' do
    map = create(:map, name: 'To be destroyed')

    visit maps_path(as: map.owner)

    accept_alert do
      click_link 'Destroy'
    end

    assert_no_text map.name
  end

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
