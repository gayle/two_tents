class RemoveUnusedFieldsOnFamily < ActiveRecord::Migration
  def self.up
    remove_column :families, :haswarmfuzzy
    remove_column :families, :photo
    remove_column :families, :photograph_content_type
    remove_column :families, :photograph_file_name
    remove_column :families, :photograph_file_size
    remove_column :families, :photolist
    remove_column :families, :principal
  end

  def self.down
    add_column :families, :haswarmfuzzy, :boolean
    add_column :families, :photo, :string
    add_column :families, :photograph_content_type, :string
    add_column :families, :photograph_file_name, :string
    add_column :families, :photograph_file_size, :string
    add_column :families, :photolist, :boolean
    add_column :families, :principal, :string
  end
end
