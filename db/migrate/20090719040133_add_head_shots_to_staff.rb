class AddHeadShotsToStaff < ActiveRecord::Migration
  def self.up
    add_column :users, :head_shot_file_name, :string
    add_column :users, :head_shot_content_type, :string
    add_column :users, :head_shot_file_size, :string
  end

  def self.down
    remove_column :users, :head_shot_file_name
    remove_column :users, :head_shot_content_type
    remove_column :users, :head_shot_file_size
  end
end
