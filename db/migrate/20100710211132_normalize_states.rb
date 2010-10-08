class NormalizeStates < ActiveRecord::Migration
  def self.up
    Participant.transaction do
      Participant.all.each do |p|
        p.update_attribute(:state, p.state[0..1].upcase) unless p.state.blank?
      end
    end
  end

  def self.down
  end
end
