class AddFormUrlsToYear < ActiveRecord::Migration
  def self.up
    add_column :years, :registration_doc, :string
    add_column :years, :registration_pdf, :string
  end

  def self.down
    remove_column :years, :registration_doc
    remove_column :years, :registration_pdf
  end
end
