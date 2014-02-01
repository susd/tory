class AddStateToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :state, :string
  end
end
