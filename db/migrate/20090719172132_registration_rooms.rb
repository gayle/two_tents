class RegistrationRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :availability, :boolean
    remove_column :registrations, :room
    add_column :registrations, :room_id, :integer

    Room.reset_column_information
    1.upto(20) { Room.create(:availability => true) }
  end

  def self.down
    Rooms.destroy_all
    add_column :registrations, :room, :string
    remove_column :registrations, :room_id
    remove_column :rooms, :availability
  end
end
