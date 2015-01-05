class Participant < ActiveRecord::Base
  has_and_belongs_to_many :years

  # TODO add these associations back once we have them
  #belongs_to :family
  #belongs_to :user, :dependent => :destroy

  # at least validate presence fields used directly or indirectlyr for sorting
  validates_presence_of :lastname, :firstname, :birthdate

  after_initialize :add_current_year

  scope :not_admin, -> { where('upper(lastname) <> ? and upper(lastname) <> ?', 'ADMIN', 'ADMINISTRATOR') }

  scope :current, -> { joins(:years).where('years.id = ?', Year.current.id) }

  # Not sure we need this.  If we do, add a spec for it.
  #scope :past, -> { joins(:years).where('years.id <> ?', Year.current.id) }

  # TODO add named scope called 'registered'

  def <=>(other_participant)
    list_name <=> other_participant.list_name
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def list_name
    "#{lastname}, #{firstname}"
  end

  private

  def add_current_year
    self.years ||= []
    current = Year.current
    self.years << current if current.present? and not self.years.include?(current)
  end


end
