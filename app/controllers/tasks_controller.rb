class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end
  
  def show
    load_task
  end
  
  def create
    @task = Task.new(task_params)
    
    if @task.valid?
      @remote = RemoteTask.new(@task.device)
      if @remote.exists?
        @task.errors.add :base, 'PXE task already exists'
      else
        status = @remote.schedule(task.job)
        unless status[:message] == 'active task'
          @task.errors.add :base, 'Could not schedule remote job'
        end
      end
    end
    
    respond_to do |format|
      if @task.save
        handle_create_success(format)
      else
        handle_create_failure(format)
      end
    end
    
  end
  
  def destroy
    load_task
    if @task.active?
      resp = delete_remote_task(@task)
      if resp[:message] == 'task deleted'
        @task.cancel!
        status_and_flash = { notice: 'Task cancelled' }
      else
        status_and_flash = { alert: 'Task could not be delete remotely' }
      end
    else
      # TODO delete remote task if one exists
      status_and_flash = { alert: 'Task already not active' }
    end
    
    redirect_to @task.device, status_and_flash
  end
  
  private
  
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
