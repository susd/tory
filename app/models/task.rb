# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  device_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

class Task < ActiveRecord::Base
  belongs_to :device
  validates_with ActiveTaskValidator
  
  
  state_machine :state, initial: :active do
    event :cancel do
      transition active: :cancelled
    end
    event :finish do
      transition active: :completed
    end
  end
end
