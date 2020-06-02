require 'test_helper'
require 'webdrivers/chromedriver'
require 'capybara'

chrome_options = Selenium::WebDriver::Chrome::Options.new
chrome_options.add_argument('--mute-audio')
chrome_options.add_argument('--window-size=1400,900')

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

Capybara.register_driver :chrome_headless do |app|
  # chrome_options.add_argument('--disable-dev-shm-usage')
  chrome_options.add_argument('--disable-gpu')
  chrome_options.add_argument('--headless')
  # chrome_options.add_argument('--no-sandbox')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by ENV.fetch('CAPYBARA_DRIVER', 'chrome_headless').downcase.to_sym

  def refresh
    page.driver.browser.navigate.refresh
  end

  def assert_field(field_selector, text:)
    assert_equal text, find_field(field_selector).value
  end
end
