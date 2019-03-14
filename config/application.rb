require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_storage/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ferret
  class Application < Rails::Application
    # Custom configuration
    config.x.application_name = "Maps & Rec"
    config.x.application_description = <<-DESC
      Welcome to the Binge Watching collection online platform,
      where you can browse the New York and London locations by chapters,
      series, and tags.
    DESC

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |generators|
      generators.template_engine :haml
    end

    # Set custom layouts for Clearance
    config.to_prepare do
      Clearance::PasswordsController.layout 'application_clearance'
      Clearance::SessionsController.layout 'application_clearance'
      Clearance::UsersController.layout 'application_clearance'
    end
  end
end
