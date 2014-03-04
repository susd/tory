module DevicesHelper
  
  def link_to_cancel(task)
    link_to 'cancel', task, {method: :delete, confirm: 'Cancel this task?', class: 'tiny alert button'}
  end
  
end