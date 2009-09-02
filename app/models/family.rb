class Family < ActiveRecord::Base
  has_many :participants
  accepts_nested_attributes_for :participants

  has_attached_file :photograph

  def familyname
    participants.collect { |p| p.lastname }.uniq.join(" and ")
  end

  def participant_attributes=(participants_attributes)
    participants_attributes.each do |attributes|
      participants << Participant.new(attributes);
    end
  end

  # Alias method 'members' to 'participants'.  Use either one.
  def members
    participants
  end
end
