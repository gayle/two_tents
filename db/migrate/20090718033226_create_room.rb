class CreateRoom < ActiveRecord::Migration
  def self.up
    create_table :rooms, :force => true do |r|
    end
  end

  def self.down
    drop_table :rooms
  end
end
