require 'rails_helper'

RSpec.describe Participant, :type => :model do
  # Copied after_initialize over from old rails 2, but it seems to cause more problems than it solves.  Taking it out until I find a good use case for it.
  #it "should add current year to new records if not specified" do
  #  year = FactoryGirl.create(:year)
  #  participant = Participant.new(firstname: "Joe", lastname: "Schmoe", birthdate: Date.new(1970,06,01))
  #  expect(participant.years).not_to be_empty
  #  expect(participant.years.size).to eq 1
  #  expect(participant.years).to include year
  #end

  it "should not blow up if no current year available" do
    participant = Participant.new(firstname: "Joe", lastname: "Schmoe", birthdate: Date.new(1970,06,01))
    expect(participant.years).to be_blank
  end

  it "should sort by 'list_name' by default" do
    FactoryGirl.create(:participant, firstname: "Zeb", lastname: "Apple")
    FactoryGirl.create(:participant, firstname: "Xenia", lastname: "Zimmerman")
    FactoryGirl.create(:participant, firstname: "Abe", lastname: "Zimmerman")
    FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple")

    expect(Participant.all.map{|p| p.list_name}).to eq ["Apple, Zeb", "Zimmerman, Xenia", "Zimmerman, Abe", "Apple, Adam"]
    expect(Participant.all.sort.map{|p| p.list_name}).to eq ["Apple, Adam", "Apple, Zeb", "Zimmerman, Abe", "Zimmerman, Xenia"]
  end

  it "should concatenate full name with first name first" do
    FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple")
    expect(Participant.first.full_name).to eq "Adam Apple"
  end

  it "should concatenate list name with last name first" do
    FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple")
    expect(Participant.first.list_name).to eq "Apple, Adam"
  end

  it "should be able to list current participants" do
    this_year = FactoryGirl.create(:year, year: 2015)
    last_year = FactoryGirl.create(:year, year: 2014)

    adam = FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple", years: [last_year, this_year])
    bill = FactoryGirl.create(:participant, firstname: "Bill", lastname: "Banana", years: [last_year])
    chad = FactoryGirl.create(:participant, firstname: "Chad", lastname: "Cherry", years: [this_year])
    #bill.years = [last_year] # remove current year that gets added by default in after_initialize. They have only past year.
    #bill.save!

    expect(Participant.not_admin.registered).to include adam
    expect(Participant.not_admin.registered).to include chad
    expect(Participant.not_admin.registered).not_to include bill
  end

  it "should be able to list past participants that are not registered this year" do
    this_year = FactoryGirl.create(:year, year: 2015)
    last_year = FactoryGirl.create(:year, year: 2014)

    adam = FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple", years: [last_year, this_year])
    bill = FactoryGirl.create(:participant, firstname: "Bill", lastname: "Banana", years: [last_year])
    chad = FactoryGirl.create(:participant, firstname: "Chad", lastname: "Cherry", years: [this_year])
    #bill.years = [last_year] # remove current year that gets added by default in after_initialize. They have only past year.
    #bill.save!

    expect(Participant.not_admin.not_registered).not_to include adam
    expect(Participant.not_admin.not_registered).to include bill
    expect(Participant.not_admin.not_registered).not_to include chad
  end

end
