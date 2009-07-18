class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.column :year, :integer
      t.column :participant_id, :integer
      t.column :room, :string
    end
    remove_column :participants, :room
  end

  def self.down
    drop_table :registrations
    add_column :participants, :room, :string
  end
end
