class MoveUserEmailAndPhonesDataIntoParticipants < ActiveRecord::Migration
  def self.up
    User.all.each do |u|
      p = u.participant
      unless p.nil?
        p.email = u.email if p.email.blank?
        p.phone = u.home_phone if p.phone.blank?
        p.mobile = u.cell_phone if p.mobile.blank?
        p.save
      end
    end
  end

  def self.down
  end
end
