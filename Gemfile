source 'https://rubygems.org'
ruby '2.5.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'bourbon', '4.2.7'
gem 'coffee-rails', '~> 4.2'
gem 'combine_pdf'
gem 'inline_svg'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'oath'
gem 'oath-generators'
gem 'neat','1.7.4'
gem 'pdfkit'
gem 'pg'
gem 'prawn'
gem 'prawn-table'
gem 'psych'
gem 'puma', '~> 3.0'
gem 'pundit'
gem 'rails', '~> 5.1'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'thor', '0.19.1'
gem 'time_for_a_boolean', git: 'https://github.com/calebthompson/time_for_a_boolean.git'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'


group :development, :test do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'climate_control'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
