class AddBedsToRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :beds, :integer, :default => 0
  end

  def self.down
    remove_column :rooms, :beds
  end
end
