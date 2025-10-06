# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.5'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 2.0'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 7.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem 'tailwindcss-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', :platforms => %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', :require => false

# Use Sass to process CSS
# gem 'sassc-rails'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', :platforms => %i[mri mingw x64_mingw]

  # Reading this guide: https://github.com/rspec/rspec-rails/tree/6-0-maintenance
  gem 'rspec-rails', '~> 8.0'
  # Reading this guide: https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md
  gem 'factory_bot_rails'

  gem 'dotenv-rails'

  # CLI Stuff
  gem 'diffy'
  gem 'tty-prompt'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Linting Stuff
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-rails'
  gem 'rubocop-rspec', :require => false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'contentful'
gem 'rack-cors', '~> 3.0'
gem 'csv'

gem 'dockerfile-rails', '>= 1.4', :group => :development
