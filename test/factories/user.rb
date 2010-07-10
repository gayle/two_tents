
Factory.define :user_seq do |u|
  u.sequence(:login) { |n| "AgentSmith#{n}" }
  u.sequence(:email) { |n| "smith#{n}@matrix.com" }
  u.sequence(:password) { |n| "monkey#{n}" }
  u.sequence(:password_confirmation) { |n| "monkey#{n}" }
  u.sequence(:position) { |n| n }
  u.sequence(:security_question) { |n| "Who is Agent #{n}?" }
  u.sequence(:security_answer) { |n| "Agent #{n} is me" }
end

