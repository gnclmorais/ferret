ruby '3.3.0'

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2'
# Use Puma as the app server
gem 'puma', '~> 6.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# Webpack handles SCSS compilation and JS minification
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Pages
gem 'haml-rails'

# Authentication
gem 'clearance'

# Data
gem 'acts_as_list'

# Assets
gem 'aws-sdk-s3', require: false

# Monitoring
gem 'newrelic_rpm'

# SEO
gem 'meta-tags'

# https://stackoverflow.com/a/70500221/590525
# Heroku needs this for networking
gem 'net-smtp', require: false

group :development, :test do
  # Place 'binding.pry' in Ruby code to stop execution and get a console
  gem 'pry-byebug'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3'
  # Env config
  gem 'dotenv-rails', '~> 2.5'
  # Testing setup
  gem 'rspec-rails'
  # Helpers & utils
  gem 'factory_bot_rails'
  gem 'shoulda'
  gem 'shoulda-matchers'
  # Style & linting
  gem 'standard'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.7'
  # Test runners
  gem 'guard'
  gem 'guard-rspec'
end

# Reporting
gem 'rollbar'
