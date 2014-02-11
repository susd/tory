class AddSiteToDevices < ActiveRecord::Migration
  def change
    add_index :devices, :site_id
  end
end
