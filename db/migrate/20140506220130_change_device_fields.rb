class ChangeDeviceFields < ActiveRecord::Migration
  def up
    change_table :devices do |t|
      t.rename :ram, :ram_str
      t.integer :ram
    end
  end
  
  def down
    change_table :devices do |t|
      t.remove :ram
      t.rename :ram_str, :ram
    end
  end
end
