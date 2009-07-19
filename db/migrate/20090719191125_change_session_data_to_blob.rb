class ChangeSessionDataToBlob < ActiveRecord::Migration
  def self.up
    remove_column :sessions, :data
    add_column :sessions, :data, :string, :limit => 1024
  end

  def self.down
  end
end
