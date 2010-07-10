class Configuration < ActiveRecord::Base

  def self.current
    find(:first, :order => "created_at DESC")
  end

  def date_range
    "#{starts_on.strftime('%B')} #{ActiveSupport::Inflector.ordinalize(starts_on.day)} - #{ActiveSupport::Inflector.ordinalize(ends_on.day)}, #{starts_on.year}"
  end

end
