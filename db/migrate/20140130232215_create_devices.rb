class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :site_id
      t.string :htmlfile
      t.string :xmlfile
      t.string :cpu
      t.string :ram
      t.string :make
      t.string :product
      t.string :serial
      t.string :uuid
      t.string :ip_addr
      t.string :_mac_address
      t.integer :_cpu_speed

      t.timestamps
    end
  end
end
