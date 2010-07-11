class NormalizeGenders < ActiveRecord::Migration
  def self.up
    Participant.transaction do
      Participant.all.each do |p|
        p.update_attribute(:gender, p.gender.upcase) unless p.gender.blank?
      end
    end
  end

  def self.down
  end
end
