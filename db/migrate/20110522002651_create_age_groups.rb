class CreateAgeGroups < ActiveRecord::Migration
  def self.up
    create_table :age_groups do |t|
      t.string :text
      t.integer :min
      t.integer :max

      t.timestamps
    end
  end

  def self.down
    drop_table :age_groups
  end
end
