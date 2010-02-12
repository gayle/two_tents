class AddSecondPhoneFieldToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :mobile, :string    
  end

  def self.down
    remove_column :participants, :mobile
  end
end
