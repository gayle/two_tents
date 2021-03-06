class Participant < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  include ParticipantsHelper

  attr_accessor :remove_from_family
  before_validation :check_if_removed_from_family
  before_validation :strip_whitespace

  def check_if_removed_from_family
    if self.remove_from_family == "1"
      self.family_id = nil
    end
  end

  def strip_whitespace
    [ self.firstname, self.lastname, self.address, self.city, self.zip, self.homechurch,
      self.phone, self.mobile, self.email, self.occupation, self.employer, self.school,
      self.grade, self.trivia].each { |s| s.strip! if s.present? }
  end

  has_and_belongs_to_many :years
  belongs_to :family
  belongs_to :user, :dependent => :destroy

  def after_initialize
    add_current_year if self.new_record?
  end

  # at least validate presence fields used directly or indirectlyr for sorting
  validates_presence_of :lastname, :firstname, :birthdate, :birthdate_string

  named_scope :main_contact, :conditions => { :main_contact => true }

  # TODO Fix the named scope to behave like the static method.  But it's like the named scope gets set in stone before
  # the test's setup (where it's creating a year) even gets a chance to run, so the current year's not defined yet.
  # named_scope :current, :joins => :years, :conditions => ["years.id = ?", Year.current.id], :order => "lastname ASC, firstname ASC"
  def self.current
    Participant.all.select {|p| p.registered_for_current_year? }
  end

  #  named_scope :not_admin, :joins => "LEFT OUTER JOIN users ON users.id", :conditions => "users.login = \"gayle\""
  named_scope :not_admin, :conditions => ["lastname <> ? and lastname <> ?",'administrator','admin']

  # List of participants registered in the past AND are NOT currently registered.
  # Participants registered for current year SHOULD NO LONGER show up in this list.
  def self.past
# TODO Fix the named scope to make it behave like the static method.  This one does not remove ones registered for current year from the past list.
#  named_scope :past, :joins => :years, :conditions => "years.id <> #{Year.current.id}", :order => "lastname ASC, firstname ASC"
    Participant.all.select {|p|
      !p.years.include? Year.current and p.lastname!="administrator"and p.lastname!="admin"
    }
  end

  def self.all_with_dietary_restrictions
    Participant.registered.select {|p|
      p.dietary_restrictions.present?
    }
  end

  def participant_address
    address || family.try(:family_address)
  end

  def participant_city
    city || family.try(:family_city)
  end

  def participant_state
    state || family.try(:family_state)
  end

  def participant_zip
    zip || family.try(:family_zip)
  end

  def full_address
    addr = ""
    addr << "#{participant_address}, " unless participant_address.blank?
    addr << "#{participant_city}, " unless participant_city.blank?
    addr << "#{participant_state} " unless participant_state.blank?
    addr << participant_zip unless participant_zip.blank?
    addr.rstrip.chomp(",")
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
    self.birthdate = ""
    @birthdate_invalid = true
  end

  def age_parts
    start_of_camp = Year.current.starts_on
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
    camp_event_year = Year.current
    current_year_birthday = Date.new(camp_event_year.starts_on.year, birthdate.month, birthdate.day)
    camp_event_year.starts_on <= current_year_birthday && current_year_birthday <= camp_event_year.ends_on
  end

  def validate
    errors.add(:birthdate, "is invalid") if @birthdate_invalid
  end

  def staff?
    user.present?
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

  def registered_for_year?(year)
    yrs = years.map {|y| y.year}
    return yrs.include?(year)
  end

  def registered_for_current_year?
    registered_for_year?(Year.current.year)
  end

  def self.registered
    #self.current.not_admin #Named scopes were behaving badly.
    current.reject {|p| p.lastname == 'administrator' or p.lastname == 'admin'}
  end
  
  def self.find_non_staff_participants
    Participant.all.reject { |p| p.user or not p.registered_for_current_year? }.sort
  end

#  def self.find_main_contacts
#    Participant.all.select { |p| p.main_contact? }
#  end
#
  def self.group_by_age_old
    participants = Participant.registered
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

  def self.group_by_age
    h = Hash.new
    age_groups = AgeGroup.all.sort_by { |ag| ag.min }
    age_groups.each do |ag|
      participants = select_participants_by_age_group(ag.min, ag.max)
      if ag.sortby == "name"
        h[ag.text] = sort_by_name(participants)
      else
        h[ag.text] = sort_by_age(participants)
      end
    end
    h
  end

  def self.group_by_grade
    participants = Participant.registered

    child_care = participants.select {|p|
      p.age <= 2
    }
    pre_k = participants.select {|p|
      (p.age >= 3 and p.age <= 5) or (p.grade.match /(kindergarten)/i if p.grade.present?)
    }
    elementary = participants.select {|p|
      p.grade.match /(^1st|first|2nd|second|3rd|third|4th|fourth)/i if p.grade.present?
    }
    middle_school = participants.select {|p|
      p.grade.match /(^5th|fifth|6th|sixth|7th|seventh|8th|eighth)/i if p.grade.present?
    }
    high_school = participants.select {|p|
      p.grade.match /(^9th|ninth|10th|tenth|11th|eleventh|12th|twelfth)/i if p.grade.present?
    }
    post_high = participants.select {|p|
      # Want to include 18 to 28.  But exclude anyone who might be 18 but whose grade is 12th or twelfth
      (p.age >= 18 and p.age <= 28) and (!p.grade.match /(12th|twelfth)/i)
    }
    other = (participants - child_care - pre_k - elementary - middle_school - high_school - post_high).reject { |p| p.grade.blank? }

    { "1: child care" => sort_by_age(child_care),
      "2: pre-k" => sort_by_age(pre_k),
      "3: elementary" => sort_by_grade(elementary),
      "4: middle school" => sort_by_grade(middle_school),
      "5: high school" => sort_by_grade(high_school),
      "6: post-high" => sort_by_name(post_high),
      "7: other" => sort_by_name(other) }
  end

  def self.group_by_birth_month
    participants = Participant.registered
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

  def add_current_year
    self.years ||= []
    current = Year.current
    self.years << current if not self.years.include?(current)
  end

  def remove_current_year
    self.years.delete(Year.current)
  end

  private

  def self.select_participants_by_age_group(min, max)
    Participant.registered.select do |p|
      p.age >= min and p.age <= max
    end
  end

  def self.sort_by_age(participants_in_group)
    participants_in_group.sort_by do |p|
      [-p.age, p.lastname, p.firstname]
    end
  end

  def self.sort_by_grade(participants_in_group)
    participants_in_group.sort_by do |p|
      sort_this = p.grade || ""
      [sort_this, p.age]
    end
    # TODO take into account that kindergarten is less than 1st.  And Fifth is greater than Second
    # TODO take into account that the string 9th is less than 10th, even though 9 is greater than 1
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
