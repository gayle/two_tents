Factory.define :audit_trail do |at|
  at.sequence(:message) { |n| "Blah #{n}" }
  at.sequence(:link) { |n| "Linkety #{n}" }
end
