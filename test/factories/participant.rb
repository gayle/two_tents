
# Note: Making every field a sequence to force the id to be unique each spawned instance.
# Weird but it works...
Factory.define :participant do |p|
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
  p.sequence(:birthdate) { |n|  Date.new(1965,01,01) - n}
  p.sequence(:trivia) { |n| "I really do have #{n} ponies" }
end

Factory.define :zero_year_old, :class=>'participant' do |p|
  p.lastname "Jones"
  p.firstname "Zero"
  p.birthdate
end

#start_of_camp = Year.current.starts_on
#zero_year_old = Participant.new(:lastname => "Zero", :firstname => "A", :birthdate => start_of_camp-18.days)
#zero_year_old.save!
#one_year_old = Participant.new(:lastname => "One", :firstname => "B", :birthdate => start_of_camp-1.year)
#one_year_old.save!
#two_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => start_of_camp-2.years)
#two_year_old.save!
#three_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => start_of_camp-3.years)
#three_year_old.save!
