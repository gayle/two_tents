class SetDefaultStartEndDatesForYearsIfMissing < ActiveRecord::Migration
  def self.up
    Year.all.each do |y|
      y.starts_on = Date.civil(y.year, 7, 1)
      y.ends_on = Date.civil(y.year, 8, 1)
      y.save
    end
  end

  def self.down
  end
end
