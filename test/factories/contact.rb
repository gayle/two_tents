Factory.define :contact do |c|
  c.sequence(:name) { |n| "Bouqet #{n}" }
  c.sequence(:email) { |n| "cynthia#{n}@hotsnail.com" }
  c.sequence(:subject) { |n| "#{n} pies" }
  c.sequence(:comment) { |n| "Spammety spam spam #{n}" }
end

