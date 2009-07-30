class AddRolesToExistingUsers < ActiveRecord::Migration
  def self.up
    admin_role = Role.create(:name => "admin")
    staff_role = Role.create(:name => "staff")

    User.first.roles << admin_role
    User.all.each do |user|
      user.roles << staff_role
    end
  end

  def self.down
    User.all.each do |user|
      user.roles.clear
    end

    Role.destroy_all
  end
end
