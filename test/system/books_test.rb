require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  test 'showing a list of Maps' do
    book = create(:book)

    visit books_path

    assert has_content? book.name
  end
end
