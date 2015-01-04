FactoryGirl.define do

  factory :year do
    year 2008
    theme "10000 lemmings can't all be wrong"
    starts_on '2008-06-01' # Date.new(2008,06,01)
    ends_on   '2008-06-05' # Date.new(2008,06,05)
    #y.sequence(:year) { |n| n+2008 } #Initial value of n is 1.  Start at year 2009.
    #y.sequence(:theme) { |n| "10000#{n} lemmings can't all be wrong" }
    #y.sequence(:starts_on) { |n|  Date.new(2008,06,01) + n.years}
    #y.sequence(:ends_on) { |n|  Date.new(2008,06,05) + n.years}
  end
end