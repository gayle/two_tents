class Registration < ActiveRecord::Base
  belongs_to :room
  belongs_to :participant
end
