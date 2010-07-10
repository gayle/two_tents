
# Note: Making every field a sequence to force the id to be unique each spawned instance.
# Weird but it works...
Factory.define :participant_seq do |p|
  p.sequence(:lastname) { |n| "Smith #{n}" }
  p.sequence(:firstname) { |n| "Argent #{n}" }
  p.sequence(:address) { |n| "42 Matix Blvd #{n}" }
  p.sequence(:city) { |n| "Hd no #{n}" }
  p.sequence(:homechurch) { |n| "Church of Smith #{n}" }
  p.sequence(:pastor) { |n| "Agent Jones #{n}" }
  p.sequence(:email) { |n| "smith#{n}@matrix.com" }
  p.sequence(:occupation) { |n| "Making world #{n} a better" }
  p.sequence(:profile) { |n| "I have #{n} ponies" }
  p.sequence(:grade) { |n| "#{n}" }
  p.sequence(:school) { |n| "School #{n}" }
  p.sequence(:employer) { |n| "The archictect, office #{n}" }
#  p.sequence(:family) { Factory(:family_seq) }
  p.sequence(:user) { Factory(:user_seq) }
  p.sequence(:employer) { |n| "The archictect, office #{n}" }
  p.sequence(:birthdate) { |n|  Date.new(1965,01,01) - n}
  p.sequence(:trivia) { |n| "I really do have #{n} ponies" }
end

