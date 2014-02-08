ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/pride"
require 'mocha/mini_test'
require 'webmock/minitest'
# require 'vcr'
# 
# VCR.configure do |c|
#   c.cassette_library_dir = 'spec/fixtures/dish_cassettes'
#   c.hook_into :webmock
#   c.debug_logger
# end

WebMock.disable_net_connect!(allow_localhost: true)

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end