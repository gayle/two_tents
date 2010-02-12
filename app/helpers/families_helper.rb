module FamiliesHelper

  def fields_for_participant(participant, &block)
    prefix = participant.new_record? ? "new" : "existing"
    fields_for("family[#{prefix}_participant_attributes][]", participant, &block)
  end

  def move_main_contact_to_front(participants)
    participants = participants.sort_by{|a| a.main_contact.to_s}
    main_family_contact=participants.pop
    participants.unshift(main_family_contact)
  end
end
