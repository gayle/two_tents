class Participant < ActiveRecord::Base
  belongs_to :family
  belongs_to :user

  before_destroy :validate_no_dependents

  # at least validate presence fields used directly or indirectlyr for sorting
#  validates_presence_of :lastname, :firstname, :birthdate, :state

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

  # Must return a numeric age
  def age
    # TODO Need to change configuration page to have a configured start date for billing, not hard coded like this
    start_of_camp = Date.parse("July 21, 2010")

    # calculated_age = ((start_of_camp - birthdate.to_date)/365.25).floor #365.25 accounts for leap years
    # This formula above doesn't work if the person's birthday is EXACTLY the first day of camp.
    # Because of the floor.  If birthdate is June 21, 2008.  And start_of_camp is June 21, 2010, then
    #((start_of_camp - birthdate.to_date)/365.25)  => 1.99863107460643

    # Is this better?
    dob = birthdate.to_date
    day_diff = start_of_camp.day - dob.day
    month_diff = start_of_camp.month - dob.month - (day_diff < 0 ? 1 : 0)
    calculated_age = start_of_camp.year - dob.year - (month_diff < 0 ? 1 : 0)

    return calculated_age


    # What about this? is it even better?
    # def age
    #   age = Date.today.year - read_attribute(:birthdate).year
    #   if Date.today.month < read_attribute(:birthdate).month ||
    #   (Date.today.month == read_attribute(:birthdate).month && read_attribute(:birthdate).day >= Date.today.day)
    #     age = age - 1
    #   end
    #   return age
    # end

  end

  def display_age
    calculated_age = age
    if calculated_age < 1
      # TODO improve this to get a specific number of months if less than 2 years
      # This doesn't work. For example, someone 11 months and 29 days, shows up as 0
      # >> age_in_months = start_of_camp.month - birthdate.month  => 0
      # age_in_months = start_of_camp.month - birthdate.month
      # return "#{calculated_age} #{pluralize(age_in_months, "month")}"

      return "less than 1 year"
    end
    return calculated_age
  end

  def validate
    errors.add(:birthdate, "is invalid") if @birthdate_invalid
  end
  
  def validate_no_dependents
    errors.add_to_base "Cannot delete a participant who is a staff user. If you really wish to delete this participant, delete the staff user first." and
      return false if self.user
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
      [p.state, p.lastname, p.firstname]
    end
  end

  def self.sort_by_birthday(participants_in_group)
    participants_in_group.sort_by do |p|
      [p.birthdate.day, p.lastname, p.firstname]
    end
  end
end
