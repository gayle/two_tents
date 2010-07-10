class RemoveUnusedFieldsOnParticipant < ActiveRecord::Migration
  def self.up
    rename_column :participants, :address1, :address
    remove_column :participants, :address2
  end

  def self.down
    rename_column :participants, :address, :address1
    add_column :participants, :address2, :string
  end
end
