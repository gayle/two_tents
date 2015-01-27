require 'rails_helper'

RSpec.describe Family, :type => :model do
  before do
    twin_birthdate = Time.now - 2.years
    # create stuff in a different order than we expect it to be in later, particularly
    # * Dogs before Cats so we can test alphabetically
    # * Main contact should be created last or close to last
    # * should not create in order or reverse order of birthdates, but it should created in weird order
    dogs = [
        FactoryGirl.create(:participant, :firstname => "Puppy2", :lastname =>  "Dogs", :birthdate => twin_birthdate),
        FactoryGirl.create(:participant, :firstname => "Odie",   :lastname =>  "Dogs", :birthdate => Time.now - 30.years),
        FactoryGirl.create(:participant, :firstname => "Puppy1", :lastname =>  "Dogs", :birthdate => twin_birthdate)
    ]
    cats = [
        FactoryGirl.create(:participant, :firstname => "Kitty",    :lastname =>  "Cats", :birthdate => Time.now - 1.year),
        FactoryGirl.create(:participant, :firstname => "Garfield", :lastname =>  "Cats", :birthdate => Time.now - 31.years, :main_contact => true),
    ]
    FactoryGirl.create(:family, participants: dogs+cats)
  end

  context "#participants" do
    it "should return participants in the correct order" do
      expect(Family.first.participants.map{|p| p.full_name}).to eq ["Garfield Cats", "Odie Dogs", "Puppy1 Dogs", "Puppy2 Dogs", "Kitty Cats"]
    end
  end

  context "#familyname" do
    it "should concatenate family name with main contact first" do
      expect(Family.first.familyname).to eq "Cats and Dogs"
    end
  end

  context ".registered" do
  end
end
