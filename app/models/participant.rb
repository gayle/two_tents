class Participant < ActiveRecord::Base
  belongs_to :family 
  belongs_to :user
  
  before_destroy :validate_no_dependents
  
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
  
  def validate_no_dependents
    errors.add_to_base "Cannot destroy a participant with a user account" and return false if self.user
  end
end
