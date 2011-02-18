class NormalizeStates < ActiveRecord::Migration
  def self.up
    results = execute %{SELECT id, state FROM participants}
    results.each do |row|
      state = row[:state]
      execute %{UPDATE participants SET state='#{row[:state][0..1]}' where id='#{row[:id]}'} if (state and state.size > 2)
    end
  end

  def self.down
  end
end
