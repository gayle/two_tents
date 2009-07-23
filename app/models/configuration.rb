class Configuration < ActiveRecord::Base
  def self.current
    find(:first, :order => "created_at DESC")
  end
end
