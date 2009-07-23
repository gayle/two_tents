class Room < ActiveRecord::Base
  has_many :registrations
  has_many :participants, :through => :registrations
end
