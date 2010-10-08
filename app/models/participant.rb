class Participant < ActiveRecord::Base

  include ActionView::Helpers::TextHelper

  belongs_to :family
  belongs_to :user

  before_destroy :validate_no_dependents

  # at least validate presence fields used directly or indirectlyr for sorting
  validates_presence_of :lastname, :firstname, :birthdate

  named_scope :main_contact, :conditions => { :main_contact => true }

  def participant_address
    address.present? ? address : family.family_address
  end

  def participant_city
    city.present? ? city : family.family_city
  end

  def participant_state
    state.present? ? state : family.family_state
  end

  def participant_zip
    zip.present? ? zip : family.family_zip
  end

  def fullname
    "#{firstname} #{lastname}"
  end

  def list_name
    "#{lastname}, #{firstname}"
  end

  def birthdate_string
    birthdate.strftime('%m/%d/%Y') if birthdate
  end

  def birthdate_string=(bd_str)
    self.birthdate = Date.parse(bd_str)
  rescue ArgumentError
    @birthdate_invalid = true
  end

  def age_parts
    start_of_camp = Configuration.current.starts_on
    dob = birthdate.to_date
    d_year = start_of_camp.year - dob.year
    d_month = start_of_camp.month - dob.month
    d_days = start_of_camp.day - dob.day
    if d_days < 0
      d_days = d_days + Time.days_in_month(dob.month, dob.year)
      d_month = d_month - 1
    end
    if d_month < 0
      d_month = d_month + 12
      d_year = d_year - 1
    end
    [d_year, d_month, d_days]
  end
    
  # Must return a numeric age
  def age
    age_parts[0]
  end

  def display_age
    a = age_parts
    if a[0] >= 2
      a[0].to_s
    elsif a[1] > 0
      "#{pluralize(a[1] + 12*a[0], "month")}"
    else
      "#{pluralize(a[2], "day")}"
    end
  end

  def birthday_during_camp?
    return false if birthdate.blank?
    conf = Configuration.current
    current_year_birthday = Date.new(conf.starts_on.year, birthdate.month, birthdate.day)
    conf.starts_on <= current_year_birthday && current_year_birthday <= conf.ends_on
  end

  def validate
    errors.add(:birthdate, "is invalid") if @birthdate_invalid
    #errors.add(:participant, "is already in the system") if duplicate?
  end
  
  def validate_no_dependents
    errors.add_to_base "Cannot delete a participant who is a staff user. If you really wish to delete this participant, delete the staff user first." and
      return false if self.user
  end

  def duplicate?
    return true if Participant.find(:first, :conditions => ["lastname = ? AND firstname = ?",
                                                            lastname, firstname])
    return false
  end

  def <=>(other_participant)
    list_name <=> other_participant.list_name
  end

  def can_delete?
    # This logic replaced from what used to be in participants\index.rhtml. Not sure if it's right tho.
    return self.user.nil? || !self.user.administrator?
  end

  def only_member_of_associated_family?
    family && family.member_count == 1
  end

  def hide_age?
    age >= 18  
  end

  # TODO This is a total hack for 2010, the first year. Eventually we need to
  # create a cross-ref association between participant and year.  For now
  # just get this done by hardcoding false for staff members who are in
  # the system, but are not attending in 2010
  def registered_for_year?(year)
    return false if
            firstname=="Jim" and lastname=="Lawrence"
    return true
  end

  def registered_for_current_year?
    registered_for_year?(Configuration.current.year)
  end

  def self.find_non_staff_participants
    Participant.all.reject { |p| p.user or not p.registered_for_current_year? }.sort
  end

  # This includes all participants but excludes the "admin" participant who is not a "real" user.
  # Eventually this will also include participants who are active for current year
  def self.find_active
    Participant.all.reject { |p| (p.user and p.user.administrator?) or
            not p.registered_for_current_year? }.sort
  end

#  def self.find_main_contacts
#    Participant.all.select { |p| p.main_contact? }
#  end
#
  def self.group_by_age
    participants = Participant.find_active
    young_children = participants.select { |p| p.age <= 5 }
    children = participants.select       { |p| p.age >= 6  and p.age <= 11 }
    youth = participants.select          { |p| p.age >= 12 and p.age <= 17 }
    adults = participants.select         { |p| p.age >= 18 }

    # Use 2-digit numbers so it sorts groups by age
    { "Age 05 and under" => sort_by_age(young_children),
      "Age 06 to 11" => sort_by_age(children),
      "Age 12 to 17" => sort_by_age(youth),
      "Age 18 and over" => sort_by_name(adults) }
  end

  def self.group_by_birth_month
    participants = Participant.find_active
    # Use 2-digit month so it sorts chronologically by month
    { "01 January"   => sort_by_birthday(participants.select { |p| p.birthdate.month == 1 }),
      "02 February"  => sort_by_birthday(participants.select { |p| p.birthdate.month == 2 }),
      "03 March"     => sort_by_birthday(participants.select { |p| p.birthdate.month == 3 }),
      "04 April"     => sort_by_birthday(participants.select { |p| p.birthdate.month == 4 }),
      "05 May"       => sort_by_birthday(participants.select { |p| p.birthdate.month == 5 }),
      "06 June"      => sort_by_birthday(participants.select { |p| p.birthdate.month == 6 }),
      "07 July"      => sort_by_birthday(participants.select { |p| p.birthdate.month == 7 }),
      "08 August"    => sort_by_birthday(participants.select { |p| p.birthdate.month == 8 }),
      "09 September" => sort_by_birthday(participants.select { |p| p.birthdate.month == 9 }),
      "10 October"   => sort_by_birthday(participants.select { |p| p.birthdate.month == 10 }),
      "11 November"  => sort_by_birthday(participants.select { |p| p.birthdate.month == 11 }),
      "12 December"  => sort_by_birthday(participants.select { |p| p.birthdate.month == 12 })
    }
  end
  private

  def self.sort_by_age(participants_in_group)
    participants_in_group.sort_by do |p|
      [-p.age, p.lastname, p.firstname]
    end
  end

  def self.sort_by_name(participants_in_group)
    participants_in_group.sort_by do |p|
      [p.lastname, p.firstname]
    end
  end

  def self.sort_by_state(participants_in_group)
    participants_in_group.sort_by do |p|
      [p.participant_state, p.lastname, p.firstname]
    end
  end

  def self.sort_by_birthday(participants_in_group)
    participants_in_group.sort_by do |p|
      [p.birthdate.day, p.lastname, p.firstname]
    end
  end
end
