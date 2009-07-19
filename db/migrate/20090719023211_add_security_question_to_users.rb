class AddSecurityQuestionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :security_question, :string
    add_column :users, :security_answer, :string
    
    User.all.each do |u|
      u.security_question = "Dads middle name?"
      u.security_answer = "Pops"
      u.save
    end
  end

  def self.down
    remove_column :users, :security_question
    remove_column :users, :security_answer
  end
end
