class Year < ActiveRecord::Base

  # TODO add these back once we have these models
  #has_and_belongs_to_many :families
  #has_and_belongs_to_many :participants

  validates_presence_of :year, :starts_on, :ends_on

  # Always sort with most recent year first by default
  def <=> (other_year)
    other_year.year <=> self.year
  end

  def self.current
    order(year: :desc).first
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
      year = Year.find_by_id(key)
      if year
        Rails.logger.debug("year '#{key}' updated with (#{value})")
        year.update_attributes!(value)
      else
        Rails.logger.warn("year '#{key}' not found, attributes not updated (#{value})")
      end
    end
  end
end
