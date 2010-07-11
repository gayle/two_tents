module FamiliesHelper

  # see http://railscasts.com/episodes/75-complex-forms-part-3
  def fields_for_participant(participant, &block)
    prefix = participant.new_record? ? "new" : "existing"
    fields_for("family[#{prefix}_participant_attributes][]", participant, &block)
  end

  def attributes_blank?(attributes)
    # check a few that should never be blank
    return (attributes[:firstname].blank? and
            attributes[:lastname].blank? and
            attributes[:birthdate].blank?)

    # maybe expand this to check for each attribute, is it blank or 0?
  end

  def main_contact?(participant)
    participant.family.main_contact == participant
  end

  # Return list of participants sorted by birthdate w/main_contact first
  def sorted_participants
    participants = @family.participants.sort_by{|a| a.birthdate || "" }
    participants.delete(@family.main_contact)
    participants.unshift(@family.main_contact)
  end
end
