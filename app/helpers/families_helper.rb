module FamiliesHelper

  # see http://railscasts.com/episodes/75-complex-forms-part-3
  def fields_for_participant(participant, &block)
    prefix = participant.new_record? ? "new" : "existing"
    fields_for("family[#{prefix}_participant_attributes][]", participant, &block)
  end

  def move_main_contact_to_front(participants)
    participants = participants.sort_by{|a| a.main_contact.to_s}
    main_family_contact=participants.pop
    participants.unshift(main_family_contact)
    participants
  end

  def attributes_blank?(attributes)
    # check a few that should never be blank
    return (attributes[:firstname].blank? and
            attributes[:lastname].blank? and
            attributes[:birthdate].blank?)

    # maybe expand this to check for each attribute, is it blank or 0?
  end

  def error_saving(family)
    "Oops! There was a problem saving family '#{family.familyname}'"    
  end
end
