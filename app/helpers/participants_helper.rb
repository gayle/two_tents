module ParticipantsHelper
  def existing_family_text
    prefix = @participant.family ? "Move" : "Add" 
    prefix + " This Person To An Existing Family"
  end

  def new_family_text
    prefix = @participant.family ? "Move" : "Add" 
    prefix + " This Person To A New Family"
  end
end
