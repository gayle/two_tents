class AddThemeToConfiguration < ActiveRecord::Migration
  def self.up
    add_column :configurations, :theme, :string
  end

  def self.down
    remove_column :configurations, :theme
  end
end
