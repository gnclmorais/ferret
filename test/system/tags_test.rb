require 'application_system_test_case'

class TagsTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    @map = create(:map, owner: @user)

    # sign_in_as(@user)
  end

  test 'map owner can add a tag' do
    create(:pin, map: @map)

    visit edit_map_url(@map, as: @user)
    assert_no_text 'coffee'

    click_link '+ add tag'
    tag_input = find('input[type="text"]')
    tag_input.set('coffee')
    tag_input.send_keys(:enter)

    refresh
    assert_text 'coffee'
  end

  test 'map owner can delete a tag' do
  end

  test 'other users see tags but no delete button' do
  end
end
