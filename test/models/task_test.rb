require 'test_helper'

describe Task do
  
  before do
    Task.destroy_all
  end
  
  it 'is invalid when another active task exists' do
    a_task = Task.create(device: devices(:one))
    b_task = Task.new(device: devices(:one))
    
    assert Task.count > 0
    a_task.state.must_equal 'active'
    b_task.valid?.must_equal false
  end
  
end