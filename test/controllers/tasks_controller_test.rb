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
    stub_delete_request(@site.pxe, @task.device.mac_address)
    delete :destroy, id: @task
    assigns(:task).state.must_equal 'cancelled'
  
    assert_redirected_to device_path(@task.device_id)
  end
  
  it "finishes the task" do
    stub_delete_request(@site.pxe, @task.device.mac_address)
    get :finish, mac: @task.device.mac_address
    assigns(:task).state.must_equal 'completed'
  end
  
end