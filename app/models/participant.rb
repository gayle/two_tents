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

  def validate_no_dependents
    errors.add_to_base "Cannot delete a participant who is a staff user. If you really wish to delete this participant, delete the staff user first." and
      return false if self.user
  end

  def <=>(other_participant)
    list_name <=> other_participant.list_name
  end

  def can_delete?
    # This logic replaced from what used to be in participants\index.rhtml. Not sure if it's right tho.
    return self.user.nil? || !self.user.administrator?
  end

  def only_member_of_associated_family?
    family && family.member_count == 1
  end

  def self.find_non_staff_participants
    Participant.all.reject { |p| p.user }.sort
  end

end
