FactoryGirl.define do
  factory :family do
    sequence(:familyname) { |n| "Smith#{n}"}
    sequence(:note) { |n| "#{n} There are a lot of smiths" }

    trait :with_participants do
      before :create do |family|
        family.participants = FactoryGirl.create_list(:participant, 2, family: family)
      end
    end
  end
end
