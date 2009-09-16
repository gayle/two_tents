class Participant < ActiveRecord::Base
  belongs_to :family
  belongs_to :user
  has_many :registrations

  before_destroy :validate_no_dependents

  def fullname
    "#{firstname} #{lastname}"
  end

  def self.find_non_staff_participants
    Participant.all.reject do |p|
      p.user
    end
  end

  def validate_no_dependents
    errors.add_to_base "Cannot delete a participant who is a staff user. If you really wish to delete this participant, delete the staff user first." and
      return false if self.user
  end
end
