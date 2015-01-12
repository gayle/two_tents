class Participant < ActiveRecord::Base
  has_and_belongs_to_many :years

  # TODO add these associations back once we have them
  #belongs_to :family
  #belongs_to :user, :dependent => :destroy

  # at least validate presence fields used directly or indirectlyr for sorting
  validates_presence_of :lastname, :firstname, :birthdate

  # Copied this over from old rails 2, but it seems to cause more problems than it solves.  Taking it out until I find a good use case for it.
  #after_initialize :add_current_year

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

  def self.not_registered
    Participant.all - Participant.registered
  end

  def <=>(other_participant)
    list_name <=> other_participant.list_name
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def list_name
    "#{lastname}, #{firstname}"
  end

  def register(year=Year.current)
    self.years ||= []
    self.years << year if not self.years.include?(year)
    self
  end

  private

  def add_current_year
    self.years ||= []
    current = Year.current
    self.years << current if current.present? and not self.years.include?(current)
  end


end
