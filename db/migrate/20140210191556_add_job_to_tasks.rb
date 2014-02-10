class AddJobToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :job, :string
  end
end
