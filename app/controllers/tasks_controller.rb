class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end
  
  def show
    load_task
  end
  
  def create
    @task = Task.new(task_params)
    @remote = create_remote_task(@task)
    failure = false
    respond_to do |format|
      if @remote.exists?
        unless @task.save
          @failure = true
          status = { alert: 'Task could not be created.' }
        end
      else
        @failure = true
        status = { alert: 'Remote task could not be schduled.' }
      end
      
      if @failure
        format.html { redirect_to @task.device, status }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to @task.device, notice: 'Task scheduled.' }
        format.json { render text: 'success', status: :created, location: @task.device }
      end
    end
  end
  
  def destroy
    load_task
    if @task.active?
      resp = delete_remote_task(@task)
      if resp[:message] == 'task deleted'
        @task.cancel!(false) # => transition but don't save (validations)
        @task.save(validate: false)
        status_and_flash = { notice: 'Task cancelled' }
      else
        #TODO: Send more specific error to user if one exists.
        status_and_flash = { alert: 'Task could not be deleted remotely' }
      end
    else
      # TODO delete remote task if one exists
      status_and_flash = { alert: 'Task already not active' }
    end
    
    redirect_to @task.device, status_and_flash
  end
  
  private
  
  def create_remote_task(task)
    #TODO: looks like RemoteTask should just be instantiated with a task
    remote = RemoteTask.new(task.device)
    remote.schedule(task.job)
    remote
  end
  
  def delete_remote_task(task)
    @remote = RemoteTask.new(task.device)
    @remote.delete
  end
  
  def handle_create_success(format)
    format.html { redirect_to @task.device, notice: 'Task scheduled.' }
    format.json { render text: 'success', status: :created, location: @task.device }
  end
  
  def handle_create_failure(format)
    format.html { redirect_to @task.device, alert: 'Task could not be scheduled' }
    format.json { render json: @task.errors, status: :unprocessable_entity }
  end
  
  def task_params
    params.require(:task).permit(:device_id, :job)
  end
  
  def load_task
    @task = Task.find(params[:id])
  end
end
