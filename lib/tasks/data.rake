
namespace :data do
  desc "Give admins and users their roles."
  task :init_roles => :environment do
    # Couldn't figure out how to get the roles in the fixtures, since it's a has_and_belongs_to_many. Just do it in code here. 
    init_all_user_roles()
    init_admin_roles()
    set_admin_password()
  end

  desc "Load and init data (load fixtures and init roles)"
  task :load => :environment do
    Rake::Task["db:fixtures:load"].invoke
    Rake::Task["data:init_roles"].invoke
    Rake::Task["data:set_admin_password"].invoke
  end

  desc "Set up admin password on a new DB"
    task :set_admin_password => :environment do
    set_admin_password()
  end
end

private

def init_all_user_roles()
  User.find(:all).each do |user|
    user.roles=[Role.find_by_name("user")]
    user.save!
  end
end

def init_admin_roles()
  admins = []
  admins << User.find_by_login("admin")
  admins << User.find_by_login("administrator")
  admins << User.find_by_login("gayle")
  admins.each do |admin|
    if admin
      admin.roles <<  Role.find_by_name("admin")
      admin.save!
    end
  end
end

def set_admin_password()
  main_admin_user = User.find_by_login("administrator")
  main_admin_user.password = "administrator"
  main_admin_user.password_confirmation = "administrator"
  main_admin_user.participant.birthdate = "1970-01-01"
  main_admin_user.participant.email = "admin@localhost" #email is required now
  main_admin_user.save!
end

#def load_seed_data(env)
#  require 'active_record/fixtures'
#  begin
#    ActiveRecord::Base.remove_connection
#    ActiveRecord::Base.establish_connection(env)
#    ActiveRecord::Base.connection.transaction do
#      Dir.glob(RAILS_ROOT + '/db/seed/*.yml').each do |file|
#        puts file
#        Fixtures.create_fixtures('db/seed', File.basename(file, '.*'))
#      end
#    end
#  ensure
#    ActiveRecord::Base.remove_connection
#    ActiveRecord::Base.establish_connection
#  end
#end

