class RemoveMainContactFromParticipants < ActiveRecord::Migration
  def self.up
    remove_column :participants, :main_contact
  end

  def self.down
    add_column :participants, :main_contact, :boolean, :default => false
  end
end
