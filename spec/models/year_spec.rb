require 'rails_helper'

RSpec.describe Year do
  context "default sorting" do
    it "sorts with most recent year first by default" do
      FactoryGirl.create(:year, year: 2009)
      FactoryGirl.create(:year, year: 2008)
      FactoryGirl.create(:year, year: 2010)
      FactoryGirl.create(:year, year: 2007)

      expect(Year.all.first.year).to be 2009
      expect(Year.all.sort.first.year).to be 2010
    end
  end

  context "#current" do
    it "with no year in the database, current returns nil" do
      expect(Year.count).to eq 0
      expect(Year.current).to be_nil
    end

    it "with at one year in the database it finds the current year" do
      FactoryGirl.create(:year) # TODO why doesn't it work if the FactoryGirl.create is outside of the "it", and up in the "context" section?
      expect(Year.count).to eq 1
      expect(Year.current).not_to be_nil
    end

    it "with multiple years in the database, 'current' is the latest chronological year" do
      FactoryGirl.create(:year, year: 2009)
      FactoryGirl.create(:year, year: 2008)
      FactoryGirl.create(:year, year: 2010)
      FactoryGirl.create(:year, year: 2007)
      expect(Year.count).to eq 4
      expect(Year.current).not_to be_nil
      expect(Year.current.year).to eq 2010
    end

    it "when we add a new year it becomes the current year" do
      FactoryGirl.create(:year)
      nextyear = Year.current.year + 1
      FactoryGirl.create(:year, year: nextyear)
      Year.current.year.should eq nextyear
    end
  end

  context "#date_range" do
    it "returns empty if starts_on is not there" do
      FactoryGirl.build(:year, year: 2015, starts_on: nil, ends_on: '2015-06-05').save(validate: false)
      expect(Year.first.date_range).to eq ""
    end

    it "returns empty if ends_on is not there" do
      FactoryGirl.build(:year, year: 2015, starts_on: '2015-06-01', ends_on: " ").save(validate: false)
      expect(Year.first.date_range).to eq ""
    end

    it "returns formatted date range if starts_on and ends_on are both there" do
      FactoryGirl.create(:year, year: 2015, starts_on: '2015-06-01', ends_on: '2015-06-05')
      expect(Year.first.date_range).to eq "June 1st - 5th, 2015"
    end
  end

  context "#update_multiple!" do
    it "should update multiple values" do
      y2008 = FactoryGirl.create(:year, year: 2008)
      y2009 = FactoryGirl.create(:year, year: 2009)
      y2010 = FactoryGirl.create(:year, year: 2010)
      years_hash = {
        "#{y2008.id}" => { "theme" => "New 2008 Theme" },
        "#{y2009.id}" => { "theme" => "New 2009 Theme" },
        "#{y2010.id}" => { "theme" => "New 2010 Theme" },
      }

      Year.update_multiple!(years_hash)

      Year.all.each do |year|
        expect(year.theme).to match /New \d{4} Theme/
      end
    end

    it "should not blow up if something in the years_hash doesn't exist" do
      y2008 = FactoryGirl.create(:year, year: 2008)
      years_hash = {
          "#{y2008.id}" => { "theme" => "New 2008 Theme" },
          "99999999" => { "theme" => "New 2010 Theme" },
      }

      Year.update_multiple!(years_hash)

      expect(Year.count).to eq 1
    end
  end
end
