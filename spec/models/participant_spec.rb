require 'rails_helper'

RSpec.describe Participant, :type => :model do
  context "#years" do
    it "should not blow up if no current year available" do
      participant = Participant.new(firstname: "Joe", lastname: "Schmoe", birthdate: Date.new(1970,06,01))
      expect(participant.years).to be_blank
    end
  end

  context "with some existing registrations" do
    before do
      @this_year = FactoryGirl.create(:year, year: 2015)
      @last_year = FactoryGirl.create(:year, year: 2014)
      @adam = FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple", years: [@last_year, @this_year])
      @bill = FactoryGirl.create(:participant, firstname: "Bill", lastname: "Banana", years: [@last_year])
      @chad = FactoryGirl.create(:participant, firstname: "Chad", lastname: "Cherry", years: [@this_year])
      #@bill.years = [@last_year] # remove current year that gets added by default in after_initialize. They have only past year.
      #@bill.save!
    end

    # Copied after_initialize over from old rails 2, but it seems to cause more problems than it solves.  Taking it out until I find a good use case for it.
    #it "should add current year to new records if not specified" do
    #  year = FactoryGirl.create(:year)
    #  participant = Participant.new(firstname: "Joe", lastname: "Schmoe", birthdate: Date.new(1970,06,01))
    #  expect(participant.years).not_to be_empty
    #  expect(participant.years.size).to eq 1
    #  expect(participant.years).to include year
    #end

    context ".registered" do
      it "should be able to list current participants" do
        expect(Participant.registered).to include @adam
        expect(Participant.registered).to include @chad
        expect(Participant.registered).not_to include @bill
      end
    end

    context ".not_registered" do
      it "should be able to list past participants that are not registered this year" do
        expect(Participant.not_registered).not_to include @adam
        expect(Participant.not_registered).to include @bill
        expect(Participant.not_registered).not_to include @chad
      end
    end

    context "#full_name" do
      it "should display first name then last name" do
        @adam = FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple", years: [@last_year, @this_year])
        expect(@adam.full_name).to eq "Adam Apple"
      end
    end

    context "#list_name" do
      it "should display last name then first name" do
        expect(@adam.list_name).to eq "Apple, Adam"
      end
    end

    context "#registered?" do
      it "should determine whether participants are registered" do
        expect(@adam.registered?(@this_year)).to eq true
        expect(@bill.registered?(@this_year)).to eq false
        expect(@chad.registered?(@this_year)).to eq true
      end
    end

    context "#full_name" do
      it "should concatenate full name with first name first" do
        expect(@adam.full_name).to eq "Adam Apple"
      end
    end

    context "#list_name" do
      it "should concatenate list name with last name first" do
        expect(@adam.list_name).to eq "Apple, Adam"
      end
    end
  end

  context "sorting" do
    it "should sort by 'list_name' by default" do
      FactoryGirl.create(:participant, firstname: "Zeb", lastname: "Apple")
      FactoryGirl.create(:participant, firstname: "Xenia", lastname: "Zimmerman")
      FactoryGirl.create(:participant, firstname: "Abe", lastname: "Zimmerman")
      FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple")

      expect(Participant.all.map{|p| p.list_name}).to eq ["Apple, Zeb", "Zimmerman, Xenia", "Zimmerman, Abe", "Apple, Adam"]
      expect(Participant.all.sort.map{|p| p.list_name}).to eq ["Apple, Adam", "Apple, Zeb", "Zimmerman, Abe", "Zimmerman, Xenia"]
    end
  end

  context "#register" do
    before do
      @this_year = FactoryGirl.create(:year, year: 2015)
      @last_year = FactoryGirl.create(:year, year: 2014)
      @elderberry = FactoryGirl.create(:participant, firstname: "Barry", lastname: "Elder")
    end

    it "should register for current year" do
      expect(@elderberry.years).not_to include @this_year

      @elderberry.register

      expect(@elderberry.years).to include @this_year
    end

    it "should not register for that year twice, no matter how many times you call register" do
      @elderberry = FactoryGirl.create(:participant, firstname: "Barry", lastname: "Elder")

      @elderberry.register
      @elderberry.register

      expect(@elderberry.years.size).to eq 1
    end

    it "should be able to register for a year other than current year" do
      @elderberry = FactoryGirl.create(:participant, firstname: "Barry", lastname: "Elder")

      @elderberry.register(@last_year)

      expect(@elderberry.years).to include @last_year
      expect(@elderberry.years).not_to include @this_year
    end
  end
end
