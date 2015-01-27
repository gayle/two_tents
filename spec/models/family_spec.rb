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

  context "registered families and participants" do
    before do
      this_year = FactoryGirl.create(:year, year: 2015)
      last_year = FactoryGirl.create(:year, year: 2014)

      # Family where all members are registered
      donald = FactoryGirl.create(:participant, :firstname => "Donald", :lastname =>  "Duck", :birthdate => Date.today-23.years,  :main_contact => true)
      daisy = FactoryGirl.create(:participant, :firstname => "Daisy",  :lastname =>  "Duck", :birthdate => Date.today-22.years)
      donald.register(this_year)
      daisy.register(this_year)
      @all_registered = FactoryGirl.create(:family, participants: [donald, daisy])

      # Family where all members were registered last year only some registered this year
      mickey = FactoryGirl.create(:participant, :firstname => "Mickey", :lastname =>  "Mouse", :birthdate => Date.today-30.years, :main_contact => true)
      minnie = FactoryGirl.create(:participant, :firstname => "Minnie", :lastname =>  "Mouse", :birthdate => Date.today-29.years)
      baby = FactoryGirl.create(:participant, :firstname => "Baby",   :lastname =>  "Mouse", :birthdate => Date.today-1.year)
      mickey.register(last_year)
      minnie.register(last_year)
      baby.register(last_year)
      minnie.register(this_year)
      baby.register(this_year)
      @some_registered = FactoryGirl.create(:family, participants: [mickey, minnie, baby])

      # Family where members were registered last year but not this year
      fred    = FactoryGirl.create(:participant, :firstname => "Fred",  :lastname   => "Flintstone", :birthdate => Date.today-40.years, :main_contact => true)
      wilma   = FactoryGirl.create(:participant, :firstname => "Wilma", :lastname   => "Flintstone", :birthdate => Date.today-38.years)
      pebbles = FactoryGirl.create(:participant, :firstname => "Pebbles", :lastname => "Flintstone", :birthdate => Date.today-2.years)
      fred.register(last_year)
      wilma.register(last_year)
      pebbles.register(last_year)
      @registered_last_year = FactoryGirl.create(:family, participants: [fred, wilma, pebbles])
    end

    it ".registered should only return families with at least one member registered for the current year" do
      expect(Family.registered.size).to eq 2
    end

    it "#registered_participants should only return participants within families who are registered for the current year" do
      # retrieve value created above fresh from database
      fam = Family.where(familyname: @some_registered.familyname).first

      expect(fam.participants.size).to eq 3 # validate data setup
      expect(fam.registered_participants.size).to eq 2
    end
  end
end
