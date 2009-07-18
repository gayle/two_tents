class Family < ActiveRecord::Base
  has_many :participants 

  has_attached_file :photograph

  # Alias method 'members' to 'participants'.  Use either one.
  def members
    participants
  end
end
