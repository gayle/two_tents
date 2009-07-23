class AddBedsToRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :beds, :integer
  end

  def self.down
  end
end
