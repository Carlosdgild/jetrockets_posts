# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5', '>= 1.5.9'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# use `dotenv-rails` for ENV variable management
gem 'dotenv-rails', '~> 2.7.5'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]
# Debugger
gem 'pry-rails', '~> 0.3.11'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# external api integrations
gem 'rest-client', '~> 2.1.0'
# Serialization
gem 'active_model_serializers', '~> 0.10.6'
# CORS
gem 'rack-cors', '~> 2.0', '>= 2.0.2'
# Paranoia
gem 'paranoia', '~> 3.0', '>= 3.0.1'

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false
  # Rspec gem used for specs generation
  gem 'rspec-rails', '~> 7.1', '>= 7.1.1'
  # linter
  gem 'rubocop-rails', '~> 2.29', '>= 2.29.1'
  gem 'rubocop-rspec', '~> 3.4'
  # use rspec for unit and integration tests
  gem 'factory_bot_rails', '~> 5.2.0'
  # use faker to generate model factories
  gem 'faker', '~> 3.4', '>= 3.4.2'
end

group :test do
  # use shoulda-matchers to enforce unit test within models
  gem 'shoulda-matchers', '~> 6.4'
  # use pundit-matchers to enforce unit test within policies
  # gem 'pundit-matchers', '~> 1.6.0'
  # use database_cleaner to truncate the contents of the database in every
  # example run
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'
  # enable mocks within context examples
  gem 'webmock', '~> 3.8.3'
  # use `timecop` for "time travel" and "time freezing" capabilities
  gem 'timecop', '~>0.9.1'
end
