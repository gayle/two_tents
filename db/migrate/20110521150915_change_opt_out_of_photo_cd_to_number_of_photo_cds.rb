class ChangeOptOutOfPhotoCdToNumberOfPhotoCds < ActiveRecord::Migration
  def self.up
    add_column :families, :number_of_photo_cds, :integer, :default => 1
    remove_column :families, :opt_out_of_photo_cd
  end

  def self.down
    remove_column :families, :number_of_photo_cds
    add_column :families, :opt_out_of_photo_cd, :boolean
  end
end
