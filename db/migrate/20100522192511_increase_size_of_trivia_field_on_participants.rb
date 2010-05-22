class IncreaseSizeOfTriviaFieldOnParticipants < ActiveRecord::Migration
  def self.up
    change_column(:participants, :trivia, :string, :limit => 500)
#change_column(table_name, column_name, type, options = {})

# change_column(:suppliers, :name, :string, :limit => 80)
# change_column(:accounts, :description, :text)

    #
  end

  def self.down
  end
end