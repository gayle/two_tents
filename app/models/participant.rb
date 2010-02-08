class Participant < ActiveRecord::Base
  belongs_to :family
  belongs_to :user
  has_many :registrations

  before_destroy :validate_no_dependents

  def fullname
    "#{firstname} #{lastname}"
  end

  def list_name
    "#{lastname}, #{firstname}"
  end

  def self.find_non_staff_participants
    Participant.all.reject { |p| p.user }.sort
  end

  def validate_no_dependents
    errors.add_to_base "Cannot delete a participant who is a staff user. If you really wish to delete this participant, delete the staff user first." and
      return false if self.user
  end

  def <=>(other_participant)
    list_name <=> other_participant.list_name
  end
end
