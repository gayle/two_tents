class Family < ActiveRecord::Base
  has_and_belongs_to_many :years
  has_many :participants, -> { order ('main_contact DESC, birthdate ASC, lastname ASC, firstname ASC') }

  # TODO rails 2 had an "accepts_nested_attributes_for" section. Will know when we get to view whether we need that.

  validates_associated :participants
  validates_presence_of :familyname, :message =>"Family Name Can't be blank"
  validates_presence_of :participants, :message =>"Participants were not added"

  after_save :check_if_empty

  before_save :concatenate_family_name

  # TODO put some validation so that we always have a main contact? Or else change concatenate_family_name to work w/o one.

  # TODO
  #scope :registered
  # or method called registered
  def self.registered(year=Year.current)
    Family.all.select{|f|
      current_participants = f.participants.select{|p|
        p.years.include? year
      }
      current_participants.present?
    }
  end

  # TODO make named scope?
  def registered_participants
    participants.select{|p| p.registered?}
  end


  def concatenate_family_name
    # put main contact's family name first.  Then concatenate the rest of the names to an array.  Then join on " and " for readability
    self.familyname = ([participants.detect{|p| p.main_contact == true}.lastname] + participants.collect { |p| p.lastname }).uniq.join(" and ")
  end

  private

  def check_if_empty
    self.reload
    if self.participants.size == 0
      self.destroy
    end
  end
end
