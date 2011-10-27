class AddSecurityQuestionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :security_question, :string
    add_column :users, :security_answer, :string
    execute %{INSERT INTO users (security_question, security_answer) values ('Dads middle name?','Pops')}
  end

  def self.down
    remove_column :users, :security_question
    remove_column :users, :security_answer
  end
end
