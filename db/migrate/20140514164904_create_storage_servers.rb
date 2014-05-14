class CreateStorageServers < ActiveRecord::Migration
  def change
    create_table :storage_servers do |t|
      t.string :priv_ip
      t.string :pub_ip
      t.references :site, index: true

      t.timestamps
    end
  end
end
