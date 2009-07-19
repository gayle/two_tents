class Participant < ActiveRecord::Base
  belongs_to :family 
  belongs_to :user
  
  def fullname
    "#{firstname} #{lastname}"
  end

  def self.find_non_staff_participants
    Participant.all.reject do |p|
      p.user
    end
  end
  def destroy
    if user.nil?
      super
    else
      errors.add(:user, "Must be nil before destroying")
    end
  end
end
