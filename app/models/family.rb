class Family < ActiveRecord::Base
  has_many :participants #TODO would like to maybe reference this as "members" instead of "participants" here? Or is that more confusing? 
end
