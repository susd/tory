require 'test_helper'

describe TasksController do
  before do
    @task = tasks(:deploy)
    @site = Site.last
  end
  
  it 'gets the index' do
    get :index
    assert_response :success
    assigns(:tasks).wont_equal nil
  end
  
  it 'should create a new task' do
    new_device = Device.create({
      mac_address: SecureRandom.hex(6), 
      site: @site, image: images(:one)
    })
    stub_check_request(@site.pxe, new_device.mac_address)
    stub_schedule_request(@site.pxe, new_device.mac_address)
    
    assert_difference(->{Task.count}) do
      post :create, task: { device_id: new_device.id, job: 'deploy' }
    end
    
    assert_redirected_to device_path(new_device.id)
  end
  
  it 'shows the task' do
    get :show, id: @task
    assert_response :success
  end
  
  it "destroys the task" do
    stub_delete_request(@site.pxe)
    delete :destroy, id: @task
    assigns(:task).state.must_equal 'cancelled'
  
    assert_redirected_to device_path(@task.device_id)
  end
  
  private
  
  def request_headers
    { 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}
  end
  
  def stub_check_request(pxe, mac)
    expected = {
      status: 200,
      body: {message: 'active task'}.to_json,
      headers: {}
    }
    stub_request(:get, "http://#{pxe}/check/#{mac}").
      with(headers: request_headers).to_return(expected)
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
  
  def stub_delete_request(pxe)
    req = {
      headers: request_headers
    }
    expected = {
      status: 200,
      body: {message: 'task deleted'}.to_json,
      headers: {}
    }
    stub_request(:delete, "http://#{pxe}/finished/#{@task.device.mac_address}").with(req).to_return(expected)
  end
  
end