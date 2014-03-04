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
  
  def request_headers
    { 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}
  end
  
  def stub_delete_request(pxe, mac)
    req = {
      headers: request_headers
    }
    expected = {
      status: 200,
      body: {message: 'task deleted'}.to_json,
      headers: {}
    }
    stub_request(:delete, "http://#{pxe}/finished/#{mac}").with(req).to_return(expected)
  end
  
  def stub_schedule_request(pxe, mac, job = 'deploy')
    req = {
      body: {"image"=>"my-image-name", "mac_address"=>mac},
      headers: request_headers.merge({ 'Content-Length'=>'59', 'Content-Type'=>'application/x-www-form-urlencoded'})
    }
    expected = {
      status: 200,
      body: {message: 'active task'}.to_json,
      headers: {}
    }
    stub_request(:post, "http://#{pxe}/#{job}").with(req).to_return(expected)
  end
  
  def stub_check_request(pxe, mac)
    expected = {
      status: 200,
      body: {message: 'task active'}.to_json,
      headers: {}
    }
    stub_request(:get, "http://#{pxe}/check/#{mac}").
      with(headers: request_headers).to_return(expected)
  end
end