require 'test_helper'

class TaskTest < ActionDispatch::IntegrationTest
  
  before do
    @device = devices(:one)
    @ts = TaskScheduler.new(@device)
  end
  
  describe "checking for running task" do
    
    it "returns 'no task' when none exist" do
      stub_request(:get, "http://10.10.1.4/check/00:11:22:33:44:55").
        to_return(status: 200, body: 'no task for that address'.to_json)
      TaskServer.check(@device).must_equal 'no task for that address'.to_json
    end
    
  end
  
  describe "scheduling a task" do
    it "schedules a deploy task"
  end
  
  
  
end