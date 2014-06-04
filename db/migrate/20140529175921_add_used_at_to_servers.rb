class AddUsedAtToServers < ActiveRecord::Migration
  def change
    add_column :servers, :used_at, :datetime
  end
end
