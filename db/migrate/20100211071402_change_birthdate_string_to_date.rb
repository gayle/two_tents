class ChangeBirthdateStringToDate < ActiveRecord::Migration
  def self.up
    # This rename/add/delete crap is for Postgres
    # We don't have any real data in birthdate yet that we need to save.
    rename_column :participants, :birthdate, :old_birthdate
    add_column :participants, :birthdate, :datetime
    remove_column :participants, :old_birthdate
  end

  def self.down
    rename_column :participants, :birthdate, :old_birthdate
    add_column :participants, :birthdate, :string
    remove_column :participants, :old_birthdate
  end
end
