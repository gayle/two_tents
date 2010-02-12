class AddFlagOnParticipantToIndicateMainContact < ActiveRecord::Migration
  def self.up
    add_column :participants, :main_contact, :boolean, :default => false
  end

  def self.down
    remove_column :participants, :main_contact
  end
end
