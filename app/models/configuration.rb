class Configuration < ActiveRecord::Base
  def current
    find(:first, :order => "created_at DESC")
  end
end
