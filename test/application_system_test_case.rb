require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def refresh
    page.driver.browser.navigate.refresh
  end

  def assert_field(field_selector, text:)
    assert_equal text, find_field(field_selector).value
  end
end
