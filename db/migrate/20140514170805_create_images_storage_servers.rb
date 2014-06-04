class CreateImagesStorageServers < ActiveRecord::Migration
  def change
    create_table :images_storage_servers, id: false do |t|
      t.integer :image_id
      t.integer :storage_server_id
    end
  end
end
