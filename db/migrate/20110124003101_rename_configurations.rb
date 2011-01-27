class RenameConfigurations < ActiveRecord::Migration
  def self.up
    rename_table :configurations, :years
  end

  def self.down
    rename_table :years, :configurations
  end
end
