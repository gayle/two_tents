require 'rails_helper'

RSpec.describe Family, :type => :model do
  before do
    @this_year = FactoryGirl.create(:year, year: 2015)
    @last_year = FactoryGirl.create(:year, year: 2014)

    # Create all this data each time so that not only do we test that the right stuff is returned,
    # but also that the wrong stuff is not returned.
    @none_registered = create_family_where_nobody_is_registered
    @all_registered = create_family_where_all_are_registered
    @some_registered = create_family_where_only_some_are_registered
    @registered_last_year = create_family_who_was_registered_last_year
    @with_no_main_contact = create_family_with_no_main_contact
  end

  context "#participants" do
    it "should return participants in the correct order" do
      expect(@none_registered.participants.map{|p| p.full_name}).to eq ["Garfield Cats", "Odie Dogs", "Puppy1 Dogs", "Puppy2 Dogs", "Kitty Cats"]
    end
  end

  context "#main_contact" do
    it "should be able to return the main contact" do
      expect(@all_registered.main_contact).not_to be_nil
      expect(@all_registered.main_contact.full_name).to eq "Donald Duck"
    end

    it "should sort with main contact first" do
      expect(@all_registered.participants.first).to eq @all_registered.main_contact
    end
  end

  context "#familyname" do
    it "should concatenate family name with main contact first" do
      expect(@none_registered.familyname).to eq "Cats and Dogs"
    end

    it "should concatenate family name even if there's no main contact" do
      expect(@with_no_main_contact.familyname).to eq "Doo and Rogers and Jones and Dinkley and Blake"
    end
  end

  context ".registered" do
    it "should only return families with at least one member registered for the current year" do
      expect(Family.registered.size).to eq 2
    end
  end

  context "#registered_participants " do
    it "should only return participants within families who are registered for the current year" do
      expect(@some_registered.participants.size).to eq 3 # validate data setup
      expect(@some_registered.registered_participants.size).to eq 2
    end
  end

  context "#full_address" do
    it "should display main contact's address" do
      expect(@all_registered.full_address).to eq "456 Water St., Lakeville, OH 44638"
      #  address={address: "456 Water St.", city: "Lakeville", state: "OH", zip: "44638"}
    end

    it "should display no address when there is no main contact" do
      expect(@with_no_main_contact.full_address).to include "unknown"
    end
  end
end

private

# This was created with enough variety to test sorting
def create_family_where_nobody_is_registered
  address={address: "123 Main St", city: "Garfield Heights", state: "OH", zip: "44105"}
  twin_birthdate = Time.now - 2.years
  # create stuff in a different order than we expect it to be in later, particularly
  # * Dogs before Cats so we can test alphabetically
  # * Main contact should be created last or close to last
  # * should not create in order or reverse order of birthdates, but it should created in weird order
  dogs = [
      FactoryGirl.create(:participant, {firstname: "Puppy2", lastname: "Dogs", birthdate: twin_birthdate}.merge(address)),
      FactoryGirl.create(:participant, {firstname: "Odie", lastname: "Dogs", birthdate: Time.now - 30.years}.merge(address)),
      FactoryGirl.create(:participant, {firstname: "Puppy1", lastname: "Dogs", birthdate: twin_birthdate}.merge(address))
  ]
  cats = [
      FactoryGirl.create(:participant, {firstname: "Kitty", lastname: "Cats", birthdate: Time.now - 1.year}.merge(address)),
      FactoryGirl.create(:participant, {firstname: "Garfield", lastname: "Cats", birthdate: Time.now - 31.years, :main_contact => true}.merge(address)),
  ]
  FactoryGirl.create(:family, participants: dogs+cats)
end

def create_family_where_all_are_registered
  address={address: "456 Water St.", city: "Lakeville", state: "OH", zip: "44638"}
  daisy = FactoryGirl.create(:participant, {firstname: "Daisy", lastname: "Duck", birthdate: Date.today-22.years}.merge(address))
  donald = FactoryGirl.create(:participant, {firstname: "Donald", lastname: "Duck", birthdate: Date.today-23.years, :main_contact => true}.merge(address))
  donald.register(@this_year)
  daisy.register(@this_year)
  FactoryGirl.create(:family, participants: [donald, daisy])
end

# Family where all members were registered last year only some registered this year
def create_family_where_only_some_are_registered
  address={address: "789 Cheese St.", city: "Munster", state: "IN", zip: "46321"}
  mickey = FactoryGirl.create(:participant, {firstname: "Mickey", lastname: "Mouse", birthdate: Date.today-30.years, :main_contact => true}.merge(address))
  minnie = FactoryGirl.create(:participant, {firstname: "Minnie", lastname: "Mouse", birthdate: Date.today-29.years}.merge(address))
  baby = FactoryGirl.create(:participant, {firstname: "Baby", lastname: "Mouse", birthdate: Date.today-1.year}.merge(address))
  mickey.register(@last_year)
  minnie.register(@last_year)
  baby.register(@last_year)
  minnie.register(@this_year)
  baby.register(@this_year)
  FactoryGirl.create(:family, participants: [mickey, minnie, baby])
end

# Family where members were registered last year but not this year
def create_family_who_was_registered_last_year
  address={address: "4321 Boulder Ave.", city: "Rocky River", state: "OH", zip: "44116"}
  fred = FactoryGirl.create(:participant, {firstname: "Fred", lastname: "Flintstone", birthdate: Date.today-40.years, main_contact: true}.merge(address))
  wilma = FactoryGirl.create(:participant, {firstname: "Wilma", lastname: "Flintstone", birthdate: Date.today-38.years}.merge(address))
  pebbles = FactoryGirl.create(:participant, {firstname: "Pebbles", lastname: "Flintstone", birthdate: Date.today-2.years}.merge(address))
  fred.register(@last_year)
  wilma.register(@last_year)
  pebbles.register(@last_year)
  FactoryGirl.create(:family, participants: [fred, wilma, pebbles])
end

def create_family_with_no_main_contact
  scooby = FactoryGirl.create(:participant, firstname: "Scooby", lastname: "Doo",     birthdate: Date.today-15.years,
                              address:"45 Maple St.",   city: "Coolsville", state: "OH", zip: "44444")
  shaggy = FactoryGirl.create(:participant, firstname: "Shaggy", lastname: "Rogers",  birthdate: Date.today-15.years,
                              address:"45 Maple St.",   city: "Coolsville", state: "OH", zip: "44444")
  fred   = FactoryGirl.create(:participant, firstname: "Fred",   lastname: "Jones",   birthdate: Date.today-15.years,
                              address:"1234 Tuna Ln.",  city: "Coolsville", state: "OH", zip: "44444")
  velma  = FactoryGirl.create(:participant, firstname: "Velma",  lastname: "Dinkley", birthdate: Date.today-15.years,
                              address:"316 Circle Dr.", city: "Coolsville", state: "OH", zip: "44444")
  daphne = FactoryGirl.create(:participant, firstname: "Daphne", lastname: "Blake",   birthdate: Date.today-15.years,
                              address:"999 Easy St.",   city: "Coolsville", state: "OH", zip: "44444")
  FactoryGirl.create(:family, participants: [scooby, shaggy, fred, velma, daphne])
end
