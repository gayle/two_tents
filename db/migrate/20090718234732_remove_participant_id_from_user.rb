class RemoveParticipantIdFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :participant_id
  end

  def self.down
  end
end
