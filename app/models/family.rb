# this is a temp comment

class Family < ActiveRecord::Base
  include FamiliesHelper

  after_save :check_if_empty

  def check_if_empty
    self.reload
    if self.participants.size == 0
      self.destroy
    end
  end

  has_and_belongs_to_many :years
  has_many :participants, :order => 'main_contact DESC, birthdate ASC, lastname ASC, firstname ASC'

  accepts_nested_attributes_for :participants, :allow_destroy => true, :reject_if => proc { 
    |attributes| (attributes['firstname'].blank? || attributes['lastname'].blank?) && (attributes['main_contact'] != "1")
  }

  has_one :main_contact, :class_name => 'Participant', :conditions => { :main_contact => true }

  validates_associated :participants
  validates_presence_of :familyname, :message =>"Family Name Can't be blank"
  validates_presence_of :participants, :message =>"Participants were not added"

# TODO make this a named scope instead
#  named_scope :registered, :joins => :years, :joins => :participants, :conditions => "years.id = #{Year.current.id}"
  def self.registered(year=Year.current)
    Family.all.select{|f|
      current_participants = f.participants.select{|p|
        p.years.include? year
      }
      current_participants.present?
    }
  end

  def familyname
    participants.collect { |p| p.lastname }.uniq.join(" and ")
  end

  def full_address
    addr = ""
    addr << "#{family_address}, " unless family_address.blank?
    addr << "#{family_city}, " unless family_city.blank?
    addr << "#{family_state} " unless family_state.blank?
    addr << family_zip unless family_zip.blank?
    addr.rstrip.chomp(",")
  end

  def family_address
    main_contact ? main_contact.address : "unknown"
  end

  def family_city
    main_contact ? main_contact.city : "unknown"
  end

  def family_state
    (main_contact and main_contact.state.present?) ? main_contact.state : "unknown"
  end

  def family_zip
    main_contact ? main_contact.zip : "unknown"
  end

  # Alias method 'members' to 'participants'.  Use either one.
  def members
    participants
  end

  def member_count
    members.size
  end

  def main_contact_name
    main_contact.firstname rescue "no main contact for this family"
  end

  def cities
    participants.collect { |p|
      arr = [p.participant_city, p.participant_state].compact
      arr.join(",")}.uniq
  end

  def states
    participants.collect { |p|  p.participant_state.nil? ? "" : p.participant_state.upcase.strip }.uniq
  end

  def self.all_states
    states = Family.registered.collect { |f| f.states }.flatten.compact
  end

  def self.all_with_cds(year=Year.current)
    Family.registered(year).select { |f| f.number_of_photo_cds > 0 }
  end

  # Usually a single family will be from only one state.  Occasionally that is
  # not the case.  We need to count them all.
  # A family with 1 member from Ohio, 2 members from Illinois, will add +1 to the count for
  # Illinois, and +1 to the count for Ohio. 
  def self.count_by_state()
    counts = {}
    all = all_states()
    all.uniq.each do |state|
      counts[state] = all.select { |s| s.upcase == state.upcase }.size
    end
    counts
  end

  def self.group_by_state
    state_group = {}
    main_contacts = Family.registered.collect { |f| f.main_contact }.compact
    all_states.uniq.each do |state|
      state_group[state] = main_contacts.collect { |p|
        p.family if (p.participant_state.upcase == state.upcase)
      }.compact
    end
    state_group
  end
  
  private
end
