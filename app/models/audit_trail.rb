class AuditTrail < ActiveRecord::Base
  def self.audit(message, link = nil)
    AuditTrail.new(:message => message, :link=>link).save!
  end
end
