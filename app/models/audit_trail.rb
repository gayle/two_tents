class AuditTrail < ActiveRecord::Base
  def initialize(m, l)
    super(:message => m, :link => l)
  end

  def self.audit(message, link = nil)
    new(message, link).save!
  end
end
