class ModifyUsersForAuthlogic < ActiveRecord::Migration
  # from https://github.com/binarylogic/authlogic_example/tree/master
  # Since you are authenticating with your User model, it can have the following columns.
  # The names of these columns can be changed with configuration. Better yet,
  # Authlogic tries to guess these names by checking for the existence of common names.
  # If you checkout the Authlogic::ActsAsAuthentic submodules in the documentation], it
  # will show you the various names checked, chances are you won't have to specify any
  # configuration for your field names, even if they aren't the same names as below.
  #
  # t.string    :login,               :null => false                # optional, you can use email instead, or both
  # t.string    :email,               :null => false                # optional, you can use login instead, or both
  # t.string    :crypted_password,    :null => false                # optional, see below
  # t.string    :password_salt,       :null => false                # optional, but highly recommended
  # t.string    :persistence_token,   :null => false                # required
  # t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
  # t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
  #
  # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
  # t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
  # t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
  # t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
  # t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
  # t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
  # t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
  # t.string    :last_login_ip                                      # optional, see Authlogic::Session:


  def up
    rename_column :users, :salt, :password_salt
    rename_column :users, :remember_token, :persistence_token
  end

  def down
    rename_column :users, :password_salt, :salt
    rename_column :users, :persistence_token, :remember_token
  end
end
