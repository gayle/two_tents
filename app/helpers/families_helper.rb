module FamiliesHelper

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

end
