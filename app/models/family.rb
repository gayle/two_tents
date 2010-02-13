class Family < ActiveRecord::Base
  include FamiliesHelper
  
  has_many :participants
  accepts_nested_attributes_for :participants

  has_attached_file :photograph
  validates_associated :participants

  def familyname
    participants.collect { |p| p.lastname }.uniq.join(" and ")
  end

  # see http://railscasts.com/episodes/75-complex-forms-part-3
  def new_participant_attributes=(participant_attributes)
    participant_attributes.each do |attributes|
      #puts "\nare they blank?\nDBG #{attributes_blank?(attributes)} DBG attributes=#{attributes.inspect}"
      participants.build(attributes) if !attributes_blank?(attributes)
    end
  end

  # see http://railscasts.com/episodes/75-complex-forms-part-3
  def existing_participant_attributes=(participant_attributes)
    participants.reject(&:new_record?).each do |participant|
      attributes = participant_attributes[participant.id.to_s]
      if attributes and not attributes_blank?(attributes)
        participant.attributes = attributes
      else
        participant.delete(participant)
      end
    end
  end

  def save_participants
    participants.each do |p|
      p.save(false)
    end
  end

  # Alias method 'members' to 'participants'.  Use either one.
  def members
    participants
  end

  def member_count
    members.size
  end

  private
end
