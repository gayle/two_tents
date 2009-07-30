class AddHealthToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :health, :boolean, :default => false
    add_column :participants, :liability, :boolean, :default => false
  end

  def self.down
    remove_column :participants, :liability
    remove_column :participants, :health
  end
end
