Factory.define :family do |f|
  f.sequence(:familyname) { |n| "Smith#{n}" }
  f.sequence(:note) { |n| "#{n} There are a lot of smiths" }

  f.sequence(:participants) do
    p=[]
    p << Factory(:participant, :main_contact => true)
    2.times { p << Factory(:participant) }
    p
  end
end
