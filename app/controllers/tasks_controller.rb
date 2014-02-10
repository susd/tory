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
        
      end
    end
    
    respond_to do |format|
      
    end
    
  end
  
  def destroy
    load_task
    # is it already finished?
    # Unschedule
    # Record history
    # mark task cancelled
  end
  
  private
  
  def handle_create_success(format)
    format.html { redirect_to tasks_path, notice: 'Task scheduled.' }
    format.json { render action: 'show', status: :created, location: @task }
  end
  
  def handle_create_failure(format)
    format.html { render action: 'new' }
    format.json { render json: @task.errors, status: :unprocessable_entity }
  end
  
  def task_params
    params.require(:task).permit(:device_id, :job)
  end
  
  def load_task
    @task = Task.find(params[:id])
  end
end
