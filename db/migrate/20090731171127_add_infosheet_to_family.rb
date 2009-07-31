class AddInfosheetToFamily < ActiveRecord::Migration
  def self.up
    add_column :families, :infosheet, :boolean, :default => false
  end

  def self.down
    remove_column :families, :infosheet
  end
end
