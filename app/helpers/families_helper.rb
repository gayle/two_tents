module FamiliesHelper

  def fields_for_participant(participant, &block)
    prefix = participant.new_record? ? "new" : "existing"
    fields_for("family[#{prefix}_participant_attributes][]", participant, &block)
  end
end
