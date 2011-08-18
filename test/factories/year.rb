Factory.define :year do |c|
  c.sequence(:year) { |n| n+2008 } #Initial value of n is 1.  Start at year 2009. 
  c.sequence(:theme) { |n| "10000#{n} lemmings can't all be wrong" }
  c.sequence(:starts_on) { |n|  Date.new(2008,06,01) + n.years}
  c.sequence(:ends_on) { |n|  Date.new(2008,06,02) + n.years}
end