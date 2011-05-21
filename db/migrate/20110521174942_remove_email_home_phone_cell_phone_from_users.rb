class RemoveEmailHomePhoneCellPhoneFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :email
    remove_column :users, :home_phone
    remove_column :users, :cell_phone
  end

  def self.down
    add_column :users, :email, :string, :limit => 100
    add_column :users, :home_phone, :string
    add_column :users, :cell_phone, :string
  end
end
