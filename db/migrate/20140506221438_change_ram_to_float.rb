class ChangeRamToFloat < ActiveRecord::Migration
  def change
    change_column :devices, :ram, :float
  end
end
