class AddStringToConfiguration < ActiveRecord::Migration
  def self.up
    add_column :configurations, :dates, :string
  end

  def self.down
  end
end
