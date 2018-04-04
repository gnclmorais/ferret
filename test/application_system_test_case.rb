require 'test_helper'
require 'capybara'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox

  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  # Capybara.register_driver :chrome do |app|
  #   browser_options = ::Selenium::WebDriver::Chrome::Options.new
  #   browser_options.args << '--headless'
  #   browser_options.args << '--no-sandbox' if ENV['CONTINUOUS_INTEGRATION']
  #   browser_options.args << '--disable-gpu'
  #   # browser_options.args << '--window-size=1920,2000'
  #   # browser_options.args '--remote-debugging-port=9222'
  #   Capybara::Selenium::Driver.new(
  #     app, browser: :chrome, options: browser_options
  #   )
  # end
  # Capybara.javascript_driver = :chrome

  # From https://github.com/rails/rails/issues/29688
  # Capybara.register_driver(:headless_chrome) do |app|
  #   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  #     chromeOptions: { args: %w[headless disable-gpu window-size=1920x1080] }
  #   )

  #   Capybara::Selenium::Driver.new(
  #     app,
  #     browser: :chrome,
  #     desired_capabilities: capabilities
  #   )
  # end
  # driven_by :headless_chrome

  def refresh
    page.driver.browser.navigate.refresh
  end

  def assert_field(field_selector, text:)
    assert_equal text, find_field(field_selector).value
  end
end
