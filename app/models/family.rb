class Family < ActiveRecord::Base
  include FamiliesHelper
  
  has_many :participants
  accepts_nested_attributes_for :participants

  has_attached_file :photograph
  validates_associated :participants

  def familyname
    participants.collect { |p| p.lastname }.uniq.join(" and ")
  end

  def family_address1
    main_contact ? main_contact.address1 : ""  
  end

  def family_address2
    main_contact ? main_contact.address2 : ""  
  end

  def family_city
    main_contact ? main_contact.city : ""
  end

  def family_state
    main_contact ? main_contact.state : ""
  end

  def family_zip
    main_contact ? main_contact.zip : ""  
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

  def main_contact
    contact = participants.select {|p|
      p.main_contact?
    }.first
  end

  def main_contact_name
    main_contact ? main_contact.firstname : "unknown"
  end

  def states
    participants.collect { |p|  p.participant_state.upcase  }.uniq
  end

  def self.all_states
    states = Family.all.collect { |f| f.states }.flatten.compact
  end

  # Usually a single family will be from only one state.  Occasionally that is
  # not the case.  We need to count them all.
  # A family with 1 member from Ohio, 2 members from Illinois, will add +1 to the count for
  # Illinois, and +1 to the count for Ohio. 
  def self.count_by_state
    counts = {}
    all = all_states()
    all.uniq.each do |state|
      counts[state] = all.select { |s| s.upcase == state.upcase }.size
    end
    counts
  end

  def self.group_by_state
    state_group = {}
    main_contacts = Family.all.collect { |f| f.main_contact }.compact
    all_states.uniq.each do |state|
      state_group[state] = main_contacts.collect { |p|
        p.family if (p.state.upcase == state.upcase)
      }.compact
    end
    state_group
  end
  
  private
end
