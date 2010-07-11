Factory.define :role do |r|
  r.sequence(:name) { |n| "Manager level #{n}" }
end
