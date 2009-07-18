class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      add_column :registrations, :year, :integer
      add_column :registrations, :participant_id, :integer
      add_column :registrations, :room, :string
    end
    remove_column :participants, :room
  end

  def self.down
    drop_table :registrations
    add_column :participants, :room, :string
  end
end
