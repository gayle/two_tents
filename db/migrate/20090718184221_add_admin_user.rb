class AddAdminUser < ActiveRecord::Migration
  def self.up
    p = Participant.new(:lastname => "administrator", 
                        :firstname => "administrator")
    p.save
    u = User.new(:login => "administrator", 
                 :password => "administrator", 
                 :password_confirmation => "administrator", 
                 :email => "admin@example.com")
    u.participant = p
    u.save
  end

  def self.down
    User.find(:first, :conditions => {:login => "administrator"}).destroy
    Participant.find(:first, 
                     :conditions => {:lastname => "administrator"}).destroy
  end
end
