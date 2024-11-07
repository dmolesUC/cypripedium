# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "actionview"
gem 'active_job_status'
gem 'bagit'
gem 'bcrypt_pbkdf' # Needed to support more secure ssh keys
gem 'bixby'
gem "blacklight_range_limit"
gem 'bootstrap', '~> 4.0'
gem 'browse-everything'
gem 'capistrano'
gem 'capistrano-bundler'
gem 'capistrano-ext'
gem 'capistrano-rails'
gem 'citeproc-ruby'
gem 'coffee-rails'
gem 'csl-styles'
gem 'devise'
gem 'devise-guests'
gem 'dotenv-rails'
gem 'ed25519'
gem 'honeybadger'
gem 'hydra-file_characterization'
gem 'hydra-role-management'
gem 'hyrax', '~> 4.0'
gem 'jbuilder'
gem 'jquery-rails'
gem 'nokogiri'
gem 'parser'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'rails-assets-tether'
gem 'rainbow'
gem 'redcarpet'
gem 'redis'
gem 'redis-activesupport'
gem 'rsolr'
gem 'rubyzip', require: 'zip'
gem 'sass-rails', '~> 6.0'
gem 'sassc-rails'
gem 'sidekiq'
gem 'simple_form'
gem 'solrizer'
gem 'strscan' # match version installed on server as system gem
gem 'terser'
gem 'turbolinks'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uri', '< 1.0' # carrierwave breaks on uri 1.x
gem 'whenever', require: false

group :development do
  gem 'capistrano-passenger'
  gem 'capistrano-sidekiq'
  gem 'listen'
  gem 'web-console'
  gem 'xray-rails'
  gem 'yard'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara'
  gem 'fcrepo_wrapper'
  gem 'solr_wrapper'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'poltergeist'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  gem 'webdrivers'
end
