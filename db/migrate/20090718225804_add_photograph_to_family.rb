class AddPhotographToFamily < ActiveRecord::Migration
  def self.up
    add_column :families, :photograph_file_name, :string
    add_column :families, :photograph_content_type, :string
    add_column :families, :photograph_file_size, :string
  end

  def self.down
    remove_column :families, :photograph_file_size
    remove_column :families, :photograph_content_type
    remove_column :families, :photograph_file_name
  end
end
