class CleanUpUnusedTables < ActiveRecord::Migration
  def change
    drop_table :storage_servers do |t|
      t.string :priv_ip
      t.string :pub_ip
      t.references :site, index: true

      t.timestamps
    end
    
    drop_table :images_storage_servers, id: false do |t|
      t.integer :image_id
      t.integer :storage_server_id
    end
    
    # remove_index :storage_servers, :site_id
  end
end
