class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :workphone, :string
    add_column :users, :mobilephone, :string
    add_column :users, :photourl, :string
    add_column :users, :position, :string
    add_column :users, :participant_id, :integer
    
  end

  def self.down
    remove_column :users, :workphone
    remove_column :users, :mobilephone
    remove_column :users, :photourl
    remove_column :users, :position
    remove_column :users, :participant_id
  end
end
