class RegistrationRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :availability, :boolean
    remove_column :registrations, :room
    add_column :registrations, :room_id, :integer
  end

  def self.down
    add_column :registrations, :room, :string
    remove_column :registrations, :room_id
    remove_column :rooms, :availability
  end
end
