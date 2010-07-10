
Factory.define :user do |u|
  u.sequence(:login) { |n| "AgentSmith#{n}" }
  u.sequence(:email) { |n| "smith#{n}@matrix.com" }
  u.sequence(:password) { |n| "monkey#{n}" }
  u.sequence(:password_confirmation) { |n| "monkey#{n}" }
  u.sequence(:position) { |n| n }
  u.sequence(:security_question) { |n| "Who is Agent #{n}?" }
  u.sequence(:security_answer) { |n| "Agent #{n} is me" }

  u.sequence(:participant) { Factory(:participant) }
end

Factory.define :single_user, :class=>'user' do |u|
  u.login 'quire'
  u.email 'quire@example.com'
  u.password 'quire69'
  u.password_confirmation 'quire69'
  u.security_question "Moms maiden name?"
  u.security_answer "Mamacita"

  u.sequence(:participant) { Factory(:participant) }  
end  



