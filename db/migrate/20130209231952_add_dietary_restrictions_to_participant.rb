class AddDietaryRestrictionsToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :dietary_restrictions, :text
  end

  def self.down
    remove_column :dietary_restrictions
  end
end
