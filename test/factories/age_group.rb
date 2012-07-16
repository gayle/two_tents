Factory.define :age_group do |grp|
  grp.sequence(:text) { |n| "Group #{n}"}
  grp.min 1
  grp.max 1
  grp.sortby "age"
end
