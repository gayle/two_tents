class Registration < ActiveRecord::Base
  belongs_to :room
  belongs_to :participant
  named_scope :this_year, lambda { { :conditions => ['year = ?', Configuration.current.year] } }
end
