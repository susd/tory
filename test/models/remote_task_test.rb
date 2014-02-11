require 'test_helper'

describe RemoteTask do
  
  before do
    @device = devices(:one)
    @rt = RemoteTask.new(@device)
    @request_headers = { 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}
    @response_base = {status: 200, headers: {}}
  end
  
  it 'wraps a RestClient::Resource' do
    @rt.resource.must_be_kind_of RestClient::Resource
  end
  
  it 'schedules a job' do
    req = {
      body: {"image"=>"my-image-name", "mac_address" => @device.mac_address},
      headers: @request_headers.merge({ 'Content-Length'=>'59', 'Content-Type'=>'application/x-www-form-urlencoded'})
    }
    expected = @response_base.merge({ body: {message: 'active task'}.to_json })
    stub_request(:post, "http://10.10.1.4/deploy").with(req).to_return(expected)
    
    resp = @rt.schedule(:deploy)
    resp.must_equal(JSON.parse(expected[:body]).symbolize_keys)
  end
  
  it 'checks for existing tasks' do
    expected = @response_base.merge({body: {message: 'active task'}.to_json})
    stub_request(:get, "http://10.10.1.4/check/#{@device.mac_address}").
      with(headers: @request_headers).to_return(expected)
    resp = @rt.check
    resp.must_equal({message: 'active task'})
  end
  
  it 'deletes jobs' do
    resp = @rt.delete
    resp.must_equal({message: 'task deleted'})
  end
  
  
end