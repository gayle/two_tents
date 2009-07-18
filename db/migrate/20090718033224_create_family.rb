class CreateFamily < ActiveRecord::Migration
  def self.up
    create_table :families, :force => true do |f|
      f.column :principal, :string
      f.column :photo, :string
      f.column :familyname, :string
      f.column :note, :string
    end
  end

  def self.down
    drop_table :families
  end
end
