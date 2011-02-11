class Year < ActiveRecord::Base

  def self.current
    find(:first, :order => "year DESC") || Year.new
  end

  def date_range
    if starts_on.present? and ends_on.present?
      "#{starts_on.strftime('%B')} #{ActiveSupport::Inflector.ordinalize(starts_on.day)} - #{ActiveSupport::Inflector.ordinalize(ends_on.day)}, #{starts_on.year}"
    else
      ""
    end
  end

  def self.update_multiple!(years_hash)
    years_hash.each do |key, value|
      year = Year.find(key)
      if year
        Rails.logger.debug("year '#{key}' updated with (#{value})")
        year.update_attributes!(value)
      else
        Rails.logger.warn("year '#{key}' not found, attributes not updated (#{value})")
      end
    end
  end
end
