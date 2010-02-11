class ChangeBirthdateStringToDate < ActiveRecord::Migration
  def self.up
    change_column :participants, :birthdate, :datetime
  end

  def self.down
    change_column :participants, :birthdate, :string
  end
end
