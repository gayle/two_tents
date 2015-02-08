class Family < ActiveRecord::Base
  has_and_belongs_to_many :years
  has_many :participants, -> { order ('main_contact DESC, birthdate ASC, lastname ASC, firstname ASC') }

  # TODO rails 2 had an "accepts_nested_attributes_for" section. Will know when we get to view whether we need that.

  has_one :main_contact, -> { where main_contact: true }, class_name: 'Participant'

  validates_associated :participants
  validates_presence_of :familyname, :message =>"Family Name Can't be blank"
  validates_presence_of :participants, :message =>"Participants were not added"

  after_save :check_if_empty

  before_save :concatenate_family_name


  # This gets a list of all families who have at least one registered participant
  # TODO make this a scope called :registered instead?  Not sure how this would work
  def self.registered(year=Year.current)
    Family.all.select{|f|
      current_participants = f.participants.select{|p|
        p.years.include? year
      }
      current_participants.present?
    }
  end

  # This gets a list of participants within the given family who are registered
  def registered_participants
    participants.select{|p| p.registered?}
  end

  def full_address
    if main_contact.nil?
      "address unknown because no main contact for this family"
    else
      addr = ""
      addr << "#{main_contact.address}, " if main_contact.address.present?
      addr << "#{main_contact.city}, "    if main_contact.city.present?
      addr << "#{main_contact.state} "    if main_contact.state.present?
      addr << "#{main_contact.zip}"       if main_contact.zip.present?
      addr
    end
  end

  def main_contact_name
    main_contact.firstname rescue "no main contact for this family"
  end

  private

  def check_if_empty
    self.reload
    if self.participants.size == 0
      self.destroy
    end
  end

  def concatenate_family_name
    last_names = []
    main_contact = participants.detect{|p| p.main_contact == true} # can't use main_contact named scope yet b/c this is a before_save filter and obj hasn't been saved to db
    last_names << main_contact.lastname if main_contact # make sure main contact is first if there is one.
    last_names += participants.collect { |p| p.lastname }
    self.familyname = last_names.uniq.join(" and ")
  end

end
