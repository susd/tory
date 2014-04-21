class AddNotesToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :notes, :text
  end
end
