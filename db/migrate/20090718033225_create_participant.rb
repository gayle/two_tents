class CreateParticipant < ActiveRecord::Migration
  def self.up
    create_table :participants, :force => true do |p|
      p.column :lastname, :string
      p.column :firstname, :string
      p.column :address1, :string
      p.column :address2, :string
      p.column :city, :string
      p.column :state, :string
      p.column :zip, :string
      p.column :homechurch, :string
      p.column :pastor, :string
      p.column :email, :string
      p.column :gender, :string
      p.column :birthdate, :string
      p.column :occupation, :string
      p.column :profile, :string
      p.column :grade, :string
      p.column :school, :string
      p.column :phone, :string
      p.column :employer, :string
      p.column :room, :string
    end
  end

  def self.down
    drop_table :participants
  end
end
