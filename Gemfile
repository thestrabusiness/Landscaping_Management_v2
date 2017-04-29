source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'combine_pdf'
gem 'pdfkit'
gem 'will_paginate'
gem 'unicorn'
gem 'simple_form'
gem 'thor', '0.19.1'
gem 'time_for_a_boolean', git: 'https://github.com/calebthompson/time_for_a_boolean.git'
gem 'neat'
gem 'bourbon'
gem 'acts_as_list'


group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'awesome_print'
  gem 'dotenv-rails'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-rails'
  gem 'climate_control'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
