require 'test_helper'

describe Task do
  
  before do
    Task.destroy_all
  end
  
  it 'is createable when no active task exists' do
    a_task = Task.create(device: devices(:one))
    Task.count.must_be :>, 0
  end
  
  it 'is invalid when another active task exists' do
    a_task = Task.create(device: devices(:one))
    b_task = Task.new(device: devices(:one))
    
    Task.count.must_be :>, 0
    a_task.state.must_equal 'active'
    b_task.valid?.must_equal false
  end
  
end