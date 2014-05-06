source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'pg', group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0.rc1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc, require: false

gem 'puma'

gem 'nokogiri'
gem 'foundation-rails'

gem 'carrierwave'

gem 'state_machine', github: 'hayesr/state_machine', branch: 'move_around_validation'

gem 'rest-client'

gem 'devise'
gem 'net-ssh'
gem 'net-sftp'

gem 'font-awesome-sass'

group :development do
  gem 'spring'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-puma', github: "seuros/capistrano-puma"
  gem 'annotate'
end

group :test do
  gem 'minitest'
  gem 'guard-minitest'
  gem 'mocha'
  gem 'minitest-spec-rails', github: 'metaskills/minitest-spec-rails'
  gem 'webmock'
  gem 'vcr'
end

group :development, :test do
  gem 'pry-rails'
end
