class RenameAFewFieldsOnUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :workphone, :home_phone
    rename_column :users, :mobilephone, :cell_phone
  end

  def self.down
    rename_column :users, :home_phone, :workphone
    rename_column :users, :cell_phone, :mobilephone
  end
end
