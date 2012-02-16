class AddDefaultAgeGroups < ActiveRecord::Migration
  def self.up
    AgeGroup.new(:min => 0, :max => 5, :text => "Age 05 and under").save
    AgeGroup.new(:min => 6, :max => 11, :text => "Age 06 to 11").save
    AgeGroup.new(:min => 12, :max => 17, :text => "Age 12 to 17").save
    AgeGroup.new(:min => 18, :max => 999, :text => "Age 18 and older").save
  end

  def self.down
    AgeGroup.all.map { |a| a.destroy }
  end
end
