class ModifyFamily < ActiveRecord::Migration
  def self.up
    add_column :families, :haswarmfuzzy, :boolean
    add_column :families, :photolist, :boolean
  end

  def self.down
    remove_column :families, :haswarmfuzzy
    remove_column :families, :photolist
  end
end
