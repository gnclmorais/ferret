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
      click_link 'Delete'
    end

    assert_no_text map.name
  end
end
