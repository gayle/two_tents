class Family < ActiveRecord::Base
  has_many :participants
  accepts_nested_attributes_for :participants

  has_attached_file :photograph

  def familyname
    participants.collect { |p| p.lastname }.uniq.join(" and ")
  end

  def new_participant_attributes=(participant_attributes)
    participant_attributes.each do |attributes|
      puts "\nare they blank?\nDBG attributes=#{attributes.inspect}"
      participants.build(attributes) if !attributes_blank?(attributes)
    end
  end

  def existing_participant_attributes=(participant_attributes)
    participants.reject(&:new_record?).each do |participant|
      attributes = participant_attributes[participant.id.to_s]
      attributes_blank?(attributes)
      if attributes
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

  def attributes_blank?(attributes)
    # check a few that should never be blank
    return (attributes[:firstname].blank? and
            attributes[:lastname].blank? and
            attributes[:birthdate].blank?)

    # maybe expand this to check for each attribute, is it blank or 0?
  end

end
