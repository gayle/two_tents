class Rooms < ActiveRecord::Base
  has_many :registrations
end
