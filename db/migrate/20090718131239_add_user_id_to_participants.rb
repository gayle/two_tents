class AddUserIdToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :user_id, :integer
  end

  def self.down
    remove_column :participants, :user_id
  end
end
