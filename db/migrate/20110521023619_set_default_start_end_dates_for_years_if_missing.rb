class SetDefaultStartEndDatesForYearsIfMissing < ActiveRecord::Migration
  def self.up
    Year.all.each do |y|
      y.starts_on = Date.civil(y.year, 7, 1) if y.starts_on.nil?
      y.ends_on = Date.civil(y.year, 8, 1) if y.ends_on.nil?
      y.save
    end
  end

  def self.down
  end
end
