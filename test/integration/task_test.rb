require 'test_helper'

class TaskTest < ActionDispatch::IntegrationTest
  
  before do
    @device = devices(:one)
    VCR.insert_cassette 'tasks', :record => :new_episodes
  end
  
  after do
    VCR.eject_cassette
  end
  
  it "schedules a task" do
    post tasks_path, {device: @device}
    assert_response :success
  end
  
end