class AddSecurityQuestionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :security_question, :string
    add_column :users, :security_answer, :string
    execute %{UPDATE users SET security_question='Dads middle name?' where security_question IS NULL}
    execute %{UPDATE users SET security_answer='Pops' where security_question IS NULL}
  end

  def self.down
    remove_column :users, :security_question
    remove_column :users, :security_answer
  end
end
