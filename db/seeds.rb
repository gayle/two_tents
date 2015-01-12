# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Year.count == 0 # make seeding idempotent
  Year.create!(:year      => Date.today.year.to_s,
               :theme     => "Enter Theme Here",
               :starts_on => (Date.today-1.week).strftime("%m/%d/%Y"),
               :ends_on   => Date.today.strftime("%m/%d/%Y"))
end
