Factory.define :configuration do |c|
  c.sequence(:year) { |n| n }
  c.sequence(:trivia) { |n| "10000#{n} lemmings can't all be wrong" }
  c.sequence(:starts_on) { |n|  Date.new(2009,01,01) - n}
  c.sequence(:ends_on) { |n|  Date.new(2009,02,01) - n}
end