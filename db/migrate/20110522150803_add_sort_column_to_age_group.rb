class AddSortColumnToAgeGroup < ActiveRecord::Migration
  def self.up
    add_column :age_groups, :sortby, :string

    ag = AgeGroup.find(:first, :conditions => { :max => 999 })
    ag.sortby = "name"
    ag.save
  end

  def self.down
    remove_column :age_groups, :sortby
  end
end
