class RemoveRegistrationsTable < ActiveRecord::Migration
  def self.up
    drop_table :registrations
  end

  def self.down
    create_table :registrations do |t|
      t.column :year, :integer
      t.column :participant_id, :integer
      t.column :room, :string
    end
  end
end
