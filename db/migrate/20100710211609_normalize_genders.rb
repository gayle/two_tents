class NormalizeGenders < ActiveRecord::Migration
  def self.up
    results = execute %{SELECT id, gender FROM participants}
    results.each do |row|
      gender = row[:gender]
      execute %{UPDATE participants SET state='#{row[:gender].upcase}' where id='#{row[:id]}'} if (gender)
    end
  end

  def self.down
  end
end
