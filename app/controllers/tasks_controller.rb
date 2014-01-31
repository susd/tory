class TasksController < ApplicationController
  
  def index
    @tasks = Task.all
  end
  
  def show
    load_task
  end
  
  def create
    # save the task
    respond_to do |format|
      if @task.save
        # create it on the task-server
        
        format.html{ redirect_to tasks_path, notice: 'Task scheduled.' }
        format.js{ render text: 'success' }
      end
    end
    
    # make sure it's there
    # return status
  end
  
  private
  
  def load_task
    @task = Task.find(params[:id])
  end
end
