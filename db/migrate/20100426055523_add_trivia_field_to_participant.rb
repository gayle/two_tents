class AddTriviaFieldToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :trivia, :string
  end

  def self.down
    remove_column :participants, :trivia
  end
end
