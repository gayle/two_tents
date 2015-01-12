class AuditTrail < ActiveRecord::Base
  validates_presence_of :message

  def self.audit(message, link = nil)
    AuditTrail.create!(:message => message, :link=>link)
  end
end
