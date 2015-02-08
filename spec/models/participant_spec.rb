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
      @someone_registered_last_and_this_year = FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple", years: [@last_year, @this_year])
      @someone_registered_last_year_only = FactoryGirl.create(:participant, firstname: "Bill", lastname: "Banana", years: [@last_year])
      @someone_registered_this_year_only = FactoryGirl.create(:participant, firstname: "Chad", lastname: "Cherry", years: [@this_year])
      #@someone_registered_last_year_only.years = [@last_year] # remove current year that gets added by default in after_initialize. They have only past year.
      #@someone_registered_last_year_only.save!
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
        expect(Participant.registered).to include @someone_registered_last_and_this_year
        expect(Participant.registered).to include @someone_registered_this_year_only
        expect(Participant.registered).not_to include @someone_registered_last_year_only
      end
    end

    context ".not_registered" do
      it "should be able to list past participants that are not registered this year" do
        expect(Participant.not_registered).not_to include @someone_registered_last_and_this_year
        expect(Participant.not_registered).to include @someone_registered_last_year_only
        expect(Participant.not_registered).not_to include @someone_registered_this_year_only
      end
    end

    context "#full_name" do
      it "should display first name then last name" do
        @someone_registered_last_and_this_year = FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple", years: [@last_year, @this_year])
        expect(@someone_registered_last_and_this_year.full_name).to eq "Adam Apple"
      end
    end

    context "#list_name" do
      it "should display last name then first name" do
        expect(@someone_registered_last_and_this_year.list_name).to eq "Apple, Adam"
      end
    end

    context "#registered?" do
      it "should determine whether participants are registered" do
        expect(@someone_registered_last_and_this_year.registered?(@this_year)).to eq true
        expect(@someone_registered_last_year_only.registered?(@this_year)).to eq false
        expect(@someone_registered_this_year_only.registered?(@this_year)).to eq true
      end
    end

    context "#full_name" do
      it "should concatenate full name with first name first" do
        expect(@someone_registered_last_and_this_year.full_name).to eq "Adam Apple"
      end
    end

    context "#list_name" do
      it "should concatenate list name with last name first" do
        expect(@someone_registered_last_and_this_year.list_name).to eq "Apple, Adam"
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
      @someone = FactoryGirl.create(:participant, firstname: "Barry", lastname: "Elder")
    end

    it "should register for current year" do
      expect(@someone.years).not_to include @this_year

      @someone.register

      expect(@someone.years).to include @this_year
    end

    it "should not register for that year twice, no matter how many times you call register" do
      @someone = FactoryGirl.create(:participant, firstname: "Barry", lastname: "Elder")

      @someone.register
      @someone.register

      expect(@someone.years.size).to eq 1
    end

    it "should be able to register for a year other than current year" do
      @someone = FactoryGirl.create(:participant, firstname: "Barry", lastname: "Elder")

      @someone.register(@last_year)

      expect(@someone.years).to include @last_year
      expect(@someone.years).not_to include @this_year
    end
  end
end