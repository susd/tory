class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :abbr
      t.string :pxe
      t.string :storage
      t.integer :code

      t.timestamps
    end
  end
end
