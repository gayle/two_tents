class Family < ActiveRecord::Base
  has_many :participants 

  # Alias method 'members' to 'participants'.  Use either one.
  def members
    participants
  end
end
