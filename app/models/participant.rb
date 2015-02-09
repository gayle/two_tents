class Participant < ActiveRecord::Base
  has_and_belongs_to_many :years

  # TODO add these associations back once we have them
  belongs_to :family
  #belongs_to :user, :dependent => :destroy

  # at least validate presence fields used directly or indirectlyr for sorting
  validates_presence_of :lastname, :firstname, :birthdate

  # This was in old rails 2 version but not really sure I need it.
  #   named_scope :main_contact, :conditions => { :main_contact => true }
  #   would be like this in rails 4:    scope :main_contact, -> { where(:main_contact => true) }

  # Copied this over from old rails 2, but it seems to cause more problems than it solves.  Taking it out until I find a good use case for it.
  #after_initialize :add_current_year

  # In old rails2, I think this used to be called 'current' but there was something else called 'registered' that was basically the same. Use this one.
  scope :registered, -> { joins(:years).where('years.id = ?', Year.current.id) }

  # Couldn't get the scope to work.  It just returned anyone who had been registered in a past year ever,
  # but I need it to exclude ones who are registered currently.
  #scope :not_registered, -> { joins(:years).where('years.id <> ?', Year.current.id) }
  # QUERY NEEDS TO LOOK LIKE THIS:
    #  SELECT participants.id, lastname, firstname, years.id, years.year
    #  FROM "participants"
    #  INNER JOIN "participants_years" ON "participants_years"."participant_id" = "participants"."id"
    #  INNER JOIN "years" ON "years"."id" = "participants_years"."year_id"
    #  WHERE firstname <> 'administrator' and lastname <> 'Admin'
    #  AND (years.id <> 5) -- 5 is 2015
    #  -- AND SOMETHING THAT SAYS IF THE PERSON IS REGISTERED FOR THIS YEAR THEN DON"T INCLUDE THIS ROW
    #  ORDER BY lastname, firstname

  # TODO Try this for the not_registered scope:
  # select distinct participants.name, participants.id
  # from participants
  # inner join participants_years on participants_years.participant_id = participants.id
  # inner join years on years.id = participants_years.year_id
  # where participant_id not in (select participant_id from participants_years where year_id = 3)
  # ;
  #
  # select participants.name, participants.id
  # from participants
  # inner join participants_years on participants_years.participant_id = participants.id
  # inner join years on years.id = participants_years.year_id
  # where participant_id not in (select participant_id from participants_years where year_id = 3)
  # group by participants.name, participants.id
  # ;

  # Note in old rails2 this used to be called 'past'.  So in controllers/views/whatever, use this instead of 'past'
  def self.not_registered
    Participant.all - Participant.registered
  end

  scope :with_dietary_restrictions, -> {registered.where('dietary_restrictions IS NOT NULL')}

  def <=>(other_participant)
    list_name <=> other_participant.list_name
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def list_name
    "#{lastname}, #{firstname}"
  end

  def full_address
    return formatted_address if formatted_address.present?
    family.nil? ? "unknown" : family.full_address
  end

  # must return a numeric age
  def age
    age_parts[:years]
  end

  def display_age
    a = age_parts
    if a[:years] >= 2
      a[:years].to_s
    elsif a[:months] > 0
      months = a[:months] + 12*a[:years]
      "#{months} #{"month".pluralize(months)}"
    else
      "#{a[:days]} #{"day".pluralize(a[:days])}"
    end
  end

  def birthday_during_camp?
    return false if birthdate.blank?
    camp_event_year = Year.current
    current_year_birthday = Date.new(camp_event_year.starts_on.year, birthdate.month, birthdate.day)
    camp_event_year.starts_on <= current_year_birthday && current_year_birthday <= camp_event_year.ends_on
  end

  def register(year=Year.current)
    self.years ||= []
    self.years << year if not self.years.include?(year)
    self
  end

  def registered?(year=Year.current)
    years.include? year
  end

  def only_member_of_associated_family?
    family && family.participants.size == 1
  end

  # TODO add this once we have the user model
  # def staff?
  #   user.present?
  # end

  # TODO add this once we have the user model
  # def can_delete?
  #   return self.user.nil? || !self.user.administrator?
  # end


  private

  def add_current_year
    self.years ||= []
    current = Year.current
    self.years << current if current.present? and not self.years.include?(current)
  end

  def formatted_address
    addr = ""
    addr << "#{address}, " if address.present?
    addr << "#{city}, "    if city.present?
    addr << "#{state} "    if state.present?
    addr << "#{zip}"       if zip.present?
    addr.rstrip.chomp(",")
    addr
  end

  def age_parts
    parts={}

    start_of_camp = Year.current.starts_on
    dob = birthdate.to_date

    parts[:years] = start_of_camp.year - dob.year
    parts[:months] = start_of_camp.month - dob.month
    parts[:days] = start_of_camp.day - dob.day
    if parts[:days] < 0
      parts[:days] = parts[:days] + Time.days_in_month(dob.month, dob.year)
      parts[:months] = parts[:months] - 1
    end
    if parts[:months] < 0
      parts[:months] = parts[:months] + 12
      parts[:years] = parts[:years] - 1
    end

    parts
  end
end
