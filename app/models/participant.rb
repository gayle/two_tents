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
end
