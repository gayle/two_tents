class SplitConfigurationDates < ActiveRecord::Migration
  def self.up
    add_column :configurations, :starts_on, :date
    add_column :configurations, :ends_on, :date
#    Configuration.all.each do |config|
#      next unless config.dates =~ / - /
#      month, starts_on_string, dummy, ends_on_string = config.dates.split(' ')
#      config.starts_on = Date.parse("#{month} #{starts_on_string} #{config.year}")
#      config.ends_on = Date.parse("#{ends_on_string} #{config.year}")
#      config.save(false)
#    end
    remove_column :configurations, :dates
  end

  def self.down
  end
end
