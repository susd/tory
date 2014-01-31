ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# require "minitest/spec"
require "minitest/pride"
require 'mocha/mini_test'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # class << self
  #   remove_method :describe
  # end
  # 
  # extend Minitest::Spec::DSL
  # 
  # register_spec_type self do |desc|
  #   desc < ActiveRecord::Base if desc.is_a? Class
  # end
end

# module Tory::Expectations
#   infect_an_assertion :assert_difference, :must_change
#   infect_an_assertion :assert_no_difference, :wont_change
# end
# 
# class Object
#   include Tory::Expectations
# end