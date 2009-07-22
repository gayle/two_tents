class Room < ActiveRecord::Base
  has_many :registrations
end
