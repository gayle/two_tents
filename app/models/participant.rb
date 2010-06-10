class Participant < ActiveRecord::Base
  belongs_to :family
  belongs_to :user
#  has_many :registrations

  before_destroy :validate_no_dependents

  validates_presence_of :birthdate

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

    if calculated_age < 1
      # TODO improve this to get a specific number of months if less than 2 years
      # This doesn't work. For example, someone 11 months and 29 days, shows up as 0
      # >> age_in_months = start_of_camp.month - birthdate.month  => 0
      # age_in_months = start_of_camp.month - birthdate.month
      # return "#{calculated_age} #{pluralize(age_in_months, "month")}"

      return "less than 1 year"
    end
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

  def self.find_non_staff_participants
    Participant.all.reject { |p| p.user }.sort
  end

  # This includes all participants but excludes the "admin" participant who is not a "real" user.
  # Eventually this will also include participants who are active for current year
  def self.find_active
    Participant.all.reject { |p| p.user and p.user.administrator? }.sort
  end

  def self.group_by_age
    participants = Participant.find_active
    young_children = participants.select { |p| p.age <= 5 }
    children = participants.select       { |p| p.age >= 6  and p.age <= 11 }
    youth = participants.select          { |p| p.age >= 12 and p.age <= 17 }
    adults = participants.select         { |p| p.age >= 18 }

    # Use 2-digit numbers so it sorts groups by age
    { "Age 05 and under" => young_children,
      "Age 06 to 11" => children,
      "Age 12 to 17" => youth,
      "Age 18 and over" => adults }
  end

end
