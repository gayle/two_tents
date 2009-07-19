class ChangeSessionDataToBlob < ActiveRecord::Migration
  def self.up
    remove_column :sessions, :data
    add_column :sessions, :data, :text
  end

  def self.down
  end
end
