FactoryGirl.define do
  factory :participant do
    firstname "Donald"
    lastname  "Duck"
    birthdate Date.parse("1978-06-01")
  end
end
