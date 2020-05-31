require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'factory_bot_rails'
require 'webdrivers/chromedriver'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods

  # Useful methods
  def assert_valid?(object)
    assert(object.valid?) { object.errors.full_messages.join(" & ") }
  end
end
