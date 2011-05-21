class AddOptOutOfPhotoCdToFamilies < ActiveRecord::Migration
  def self.up
    add_column :families, :opt_out_of_photo_cd, :boolean
  end

  def self.down
    remove_column :families, :opt_out_of_photo_cd
  end
end
