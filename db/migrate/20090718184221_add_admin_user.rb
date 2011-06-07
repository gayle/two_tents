class AddAdminUser < ActiveRecord::Migration
  def self.up
    execute %{INSERT INTO participants (lastname, firstname)
                          values ('administrator', 'administrator')}
    execute %{INSERT INTO users (login, crypted_password, email)
                          values ('administrator', 'administrator', 'administrator@example.com')}
  end

  def self.down
    execute %{DELETE FROM participants WHERE (lastname = 'administrator' and firstname = 'administrator')}
    execute %{DELETE FROM users WHERE (login = 'administrator') }
  end
end
