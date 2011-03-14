class CreateTablesThatCrossRefWithYears < ActiveRecord::Migration
  def self.up
    # year_results = execute("SELECT * FROM years ORDER BY year ASC")
    year_2010_id = execute("SELECT * FROM years WHERE year = '2010'")[0].id # year_results[0]["id"]

    create_table :families_years, :id => false do |t|
      t.integer :family_id
      t.integer :year_id
      t.timestamps
    end
    # initially, have every family use a previous year
    execute("SELECT id FROM families").each do |family|
      insert %{INSERT INTO families_years (family_id, year_id) VALUES('#{family["id"]}','#{year_2010_id}')}
    end

    create_table :participants_years, :id => false do |t|
      t.integer :participant_id
      t.integer :year_id
      t.timestamps
    end
    # initially, have every participant use a previous year
    execute("SELECT id FROM participants").each do |participant|
      insert %{INSERT INTO participants_years (participant_id, year_id) VALUES('#{participant["id"]}','#{year_2010_id}')}
    end
  end

  def self.down
    drop_table :families_years
    drop_table :participants_years
  end
end
