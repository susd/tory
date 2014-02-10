class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :device
      
      t.timestamps
    end
  end
end
