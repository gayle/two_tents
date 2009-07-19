class ChangeSessionDataToBlob < ActiveRecord::Migration
  def self.up
    remove_column :sessions, :data
    add_column :sessions, :data, :string, :limit => 500
  end

  def self.down
  end
end
