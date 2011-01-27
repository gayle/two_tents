class Year < ActiveRecord::Base

  def self.current
    find(:first, :order => "created_at DESC")
  end

  def date_range
    if starts_on.present? and ends_on.present?
      "#{starts_on.strftime('%B')} #{ActiveSupport::Inflector.ordinalize(starts_on.day)} - #{ActiveSupport::Inflector.ordinalize(ends_on.day)}, #{starts_on.year}"
    else
      ""
    end
  end

end
