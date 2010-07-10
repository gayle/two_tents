class RemoveUnusedFieldsOnUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :head_shot_file_name
    remove_column :users, :head_shot_file_size
    remove_column :users, :photourl
  end

  def self.down
    add_column :users, :head_shot_file_name, :string
    add_column :users, :head_shot_file_size, :string
    add_column :users, :photourl, :string
  end
end
