class IncreaseSizeOfUserFieldsForAuthlogic < ActiveRecord::Migration
  def up
    # increase fields from size 40 to 255
    change_column :users, :login,             :string
    change_column :users, :crypted_password,  :string
    change_column :users, :password_salt,     :string
    change_column :users, :persistence_token, :string
  end

  def down
    # no need to reduce column sizes if migrating down
  end
end
