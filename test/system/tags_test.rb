require 'application_system_test_case'

class TagsTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    @map = create(:map, owner: @user)
  end

  test 'map owner can add a tag' do
    create(:pin, map: @map)
    visit edit_map_path(@map, as: @user)
    assert_no_text 'v60'

    within '#places-panel' do
      click_button '+ add tag'
      tag_input = first('input[type="text"]')
      tag_input.set('v60')
      tag_input.send_keys(:enter)
    end

    refresh
    assert_text 'v60'
  end

  test 'map owner can delete a tag' do
    pin = create(:pin, map: @map)
    create(:tagged_pin, pin: pin, tag: create(:tag, name: 'espresso'))
    binding.pry
    visit edit_map_path(@map, as: @user)
    assert_text 'espresso'

    within '#places-panel' do
      find('.is-delete').click
    end

    refresh
    assert_no_text 'espresso'
  end

  test 'other users see tags but no delete button' do
  end
end
