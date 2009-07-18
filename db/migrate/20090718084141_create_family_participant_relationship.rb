class CreateFamilyParticipantRelationship < ActiveRecord::Migration
  def self.up
    add_column :participants, :family_id, :integer
    add_column :families, :participant_id, :integer
  end

  def self.down
    remove_column :participants, :family_id
  end
end
