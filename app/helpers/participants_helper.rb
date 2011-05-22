module ParticipantsHelper
  def existing_family_text
    prefix = @participant.family ? "Move" : "Add" 
    prefix + " This Person To An Existing Family"
  end

  def new_family_text
    prefix = @participant.family ? "Move" : "Add" 
    prefix + " This Person To A New Family"
  end

  def email_already_exists?
    duplicates = Participant.all.select do |p|
        p.email == self.email and
        p.id != self.id
    end
    duplicates.size > 0
  end
end
