class AddMainContactIdToFamilies < ActiveRecord::Migration
  def self.up
    add_column :families, :main_contact_id, :integer

    Family.all.each do |family|
      family.participants.each do |participant|
        family.update_attribute(:main_contact_id, participant.id) if participant.main_contact?
      end
    end
  end

  def self.down
    remove_column :families, :main_contact_id
  end
end
