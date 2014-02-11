class AddImageToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :image_id, :integer
    add_index :devices, :image_id
  end
end
