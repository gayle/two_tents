class DropFilesTable < ActiveRecord::Migration
  def self.up
    drop_table :files
  end

  def self.down
    create_table :files do |t|
      t.string :description
      t.boolean :dated
      t.string :att_file_name
      t.string :att_content_type
      t.string :att_file_size
      t.timestamps
    end
  end
end
