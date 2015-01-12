require 'rails_helper'

RSpec.describe AgeGroup, :type => :model do
  context "#participants" do
    # Why the heck can't I just set these as variables in the context instead of having to call a method in the 'it'?
    def setup_default_age_groups
      @zero_to_five =        FactoryGirl.create(:age_group, :min=>0, :max=>5)
      @six_to_eleven =       FactoryGirl.create(:age_group, :min=>6, :max=>11)
      @twelve_to_seventeen = FactoryGirl.create(:age_group, :min=>12, :max=>17)
      @eighteen_and_up =     FactoryGirl.create(:age_group, :min=>18, :max=>999)
    end

    # Why the heck can't I just set these as variables in the context instead of having to call a method in the 'it'?
    def initialize_year
      today = Date.today
      FactoryGirl.create(:year, year: today.year, starts_on: today-7.days, ends_on: today)
      @start_of_camp = Year.current.starts_on
    end

    it "should get all registered participants in each age group" do
      setup_default_age_groups
      initialize_year

      zero_year_old      = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Zero", :birthdate => @start_of_camp-18.days).register
      five_year_old      = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Five", :birthdate => @start_of_camp-5.years).register
      six_year_old       = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Six", :birthdate => @start_of_camp-6.years).register
      eleven_year_old    = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Eleven", :birthdate => @start_of_camp-11.years).register
      twelve_year_old    = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Twelve", :birthdate => @start_of_camp-12.years).register
      seventeen_year_old = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Seventeen", :birthdate => @start_of_camp-17.years).register
      eighteen_year_old  = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Eightteen", :birthdate => @start_of_camp-18.years).register
      sixty_year_old     = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Sixty", :birthdate => @start_of_camp-60.years).register

      expect(@zero_to_five.participants).to include zero_year_old
      expect(@zero_to_five.participants).to include five_year_old
      expect(@zero_to_five.participants).not_to include six_year_old

      expect(@six_to_eleven.participants).to include six_year_old
      expect(@six_to_eleven.participants).to include eleven_year_old
      expect(@six_to_eleven.participants).not_to include twelve_year_old

      expect(@twelve_to_seventeen.participants).to include twelve_year_old
      expect(@twelve_to_seventeen.participants).to include seventeen_year_old
      expect(@twelve_to_seventeen.participants).not_to include eighteen_year_old

      expect(@eighteen_and_up.participants).to include eighteen_year_old
      expect(@eighteen_and_up.participants).to include sixty_year_old
      expect(@eighteen_and_up.participants).not_to include zero_year_old
    end

    it "should only get registered participants in an age group" do
      setup_default_age_groups
      initialize_year

      registered_zero_year_old   = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Zero", :birthdate => @start_of_camp-18.days).register
      unregistered_zero_year_old = FactoryGirl.create(:participant, :lastname => "Jones", :firstname => "Zero", :birthdate => @start_of_camp-18.days)

      expect(@zero_to_five.participants).to include registered_zero_year_old
      expect(@zero_to_five.participants).not_to include unregistered_zero_year_old
    end
  end
end
