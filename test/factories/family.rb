Factory.define :family do |f|
  f.sequence(:familyname) { |n| "Smith#{n}" }
  f.sequence(:note) { |n| "#{n} There are a lot of smiths" }

  f.sequence(:participants) do
    p=[]
    3.times { p << Factory(:participant) }
    p
  end
end
