class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.belongs_to :site, index: true
      t.string :ip_addr
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
