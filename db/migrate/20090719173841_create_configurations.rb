class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.integer :year
      t.timestamps
    end
    #Configuration.create(:year => 2010)
  end

  def self.down
    drop_table :configurations
  end
end
