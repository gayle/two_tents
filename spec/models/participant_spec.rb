require 'rails_helper'

RSpec.describe Participant, :type => :model do
  context "#years" do
    it "should not blow up if no current year available" do
      participant = FactoryGirl.create(:participant, firstname: "Joe", lastname: "Schmoe", birthdate: Date.new(1970,06,01))
      expect(participant.years).to be_blank
    end
  end

  context "with participants registered for various years" do
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
    #  participant = FactoryGirl.create(firstname: "Joe", lastname: "Schmoe", birthdate: Date.new(1970,06,01))
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

    context ".with_dietary_restrictions" do
      it "should only return participants with dietary restrictions who are registered this year" do
        @someone_registered_last_year_only.update_attributes!(dietary_restrictions: "Peanut Allergy")
        @someone_registered_this_year_only.update_attributes!(dietary_restrictions: "Gluten Allergy")

        expect(Participant.with_dietary_restrictions.map{|p| p.dietary_restrictions}).to eq ["Gluten Allergy"]
      end
    end

    context "#registered?" do
      it "should determine whether participants are registered" do
        expect(@someone_registered_last_and_this_year.registered?(@this_year)).to eq true
        expect(@someone_registered_last_year_only.registered?(@this_year)).to eq false
        expect(@someone_registered_this_year_only.registered?(@this_year)).to eq true
      end
    end

    context "#only_member_of_associated_family?" do
      it "should be true if only member in family" do
        FactoryGirl.create(:family, participants: [@someone_registered_this_year_only])
        expect(@someone_registered_this_year_only.only_member_of_associated_family?).to eq true
      end

      it "should be false if other family members" do
        FactoryGirl.create(:family, participants: [@someone_registered_last_and_this_year, @someone_registered_this_year_only])
        expect(@someone_registered_this_year_only.only_member_of_associated_family?).to eq false
      end
    end
  end

  context "When displaying personal information" do
    before do
      @adam = FactoryGirl.create(:participant, firstname: "Adam", lastname: "Apple")
    end

    context "#full_name" do
      it "should display first name then last name" do
        expect(@adam.full_name).to eq "Adam Apple"
      end
    end

    context "#list_name" do
      it "should display last name then first name" do
        expect(@adam.list_name).to eq "Apple, Adam"
      end
    end

    context "#participant_address" do
      before do
        @address_attributes = {address: "123 Main St.", city: "Anytown", state: "OH", zip: "44444"}
      end

      it "should not blow up if participant has no address" do
        expect(@adam.full_address).to eq "unknown"
      end

      it "should get participant address" do
        @adam.update_attributes!(@address_attributes)
        expect(@adam.full_address).to eq "123 Main St., Anytown, OH 44444"
      end

      it "should get family's address if participant's address is blank" do
        @bill = FactoryGirl.create(:participant, firstname: "Bill", lastname: "Banana")

        # full_address should not blow up at first when participant is not yet part of a family
        expect(@bill.full_address).to eq "unknown"

        # add participant to a family who has a main contact
        @adam.update_attributes!({main_contact: true}.merge(@address_attributes))
        FactoryGirl.create(:family, participants: [@adam, @bill])

        # Now address should have something
        expect(@bill.full_address).to eq @adam.full_address
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

  context "age-related things" do
    before do
      @camp_start = Date.new(2010,7,21)
      @camp_end = @camp_start+5.days
      FactoryGirl.create(:year, year: @camp_start.year, starts_on: @camp_start, ends_on: @camp_end)
    end

    context "#age and #display_age" do
      it "when participant is under one month old" do
        p = FactoryGirl.create(:participant, birthdate: @camp_start - 10.days)
        expect(p.age).to eq 0
        expect(p.display_age).to eq "10 days"
      end

      it "when participant is barely over one month old" do
        p = FactoryGirl.create(:participant, birthdate: @camp_start - 31.days)
        expect(p.age).to eq 0
        expect(p.display_age).to eq "1 month"
      end

      it "when participant is barely under one year old" do
        p = FactoryGirl.create(:participant, birthdate: @camp_start - 11.months - 29.days)
        expect(p.age).to eq 0
        expect(p.display_age).to eq "11 months"
      end

      it "when participant is over one year and less than 2 years" do
        p = FactoryGirl.create(:participant, birthdate: @camp_start - 1.year - 10.months - 10.days)
        expect(p.age).to eq 1
        expect(p.display_age).to eq "22 months"
      end

      it "when participant is over 2 years" do
        p = FactoryGirl.create(:participant, birthdate: @camp_start - 2.years)
        expect(p.age).to eq 2
        expect(p.display_age).to eq "2"
      end
    end

    context "#birthday_during_camp?" do
      it "should be true if birthday is on first day of camp" do
        p = FactoryGirl.create(:participant, birthdate: Date.new(@camp_start.year-10, @camp_start.month, @camp_start.day))
        expect(p.birthday_during_camp?).to eq true
      end

      it "should be true if birthday is on last day of camp" do
        p = FactoryGirl.create(:participant, birthdate: Date.new(@camp_end.year-10, @camp_end.month, @camp_end.day))
        expect(p.birthday_during_camp?).to eq true
      end

      it "should be false if birthday is not during camp" do
        p = FactoryGirl.create(:participant, birthdate: @camp_start - 10.years + 30.days)
        expect(p.birthday_during_camp?).to eq false
      end
    end

    context "#hide_age?" do
      it "should hide if 18 and over" do
        p = FactoryGirl.create(:participant, birthdate: @camp_start - 18.years)
        expect(p.hide_age?).to eq true
      end

      it "should not hide if under 18" do
        p = FactoryGirl.create(:participant, birthdate: @camp_start - 17.years)
        expect(p.hide_age?).to eq false
      end
    end
  end

  context "grouping" do
    context "#group_by_age" do
      it "should stuff" do
        pending
        #binding.pry # how many participants do I have?
      end
    end

    context "#group_by_grade" do
      before do
        @camp_start = Date.new(2010,7,21)
        @camp_end = @camp_start+5.days
        @this_year = FactoryGirl.create(:year, year: @camp_start.year, starts_on: @camp_start, ends_on: @camp_end)
      end

      it "should only include registered participants" do
        zero_year_old  = FactoryGirl.create(:participant, :lastname => "Zero", firstname: "A", birthdate: @camp_start-18.days)
        one_year_old   = FactoryGirl.create(:participant, :lastname => "One",  firstname: "B", birthdate: @camp_start-1.year).register

        participants_by_grade = Participant.group_by_grade
        child_care_group = participants_by_grade["1: child_care"]

        expect(child_care_group).not_to be_blank
        expect(child_care_group).not_to include zero_year_old
        expect(child_care_group).to include one_year_old
      end

      it "'child care' group should include age 0 to 2" do
        zero_year_old  = FactoryGirl.create(:participant, :lastname => "Zero", firstname: "A", birthdate: @camp_start-18.days).register
        one_year_old   = FactoryGirl.create(:participant, :lastname => "One",  firstname: "B", birthdate: @camp_start-1.year).register
        two_year_old   = FactoryGirl.create(:participant, :lastname => "Two",  firstname: "C", birthdate: @camp_start-2.years).register
        three_year_old = FactoryGirl.create(:participant, :lastname => "Two",  firstname: "D", birthdate: @camp_start-3.years).register

        participants_by_grade = Participant.group_by_grade
        child_care_group = participants_by_grade["1: child_care"]

        expect(child_care_group).not_to be_blank
        expect(child_care_group).to include zero_year_old
        expect(child_care_group).to include one_year_old
        expect(child_care_group).to include two_year_old
        expect(child_care_group).not_to include three_year_old
      end

      it "'pre-k' group should include age 3 to5 going into kindergarten" do
        two_year_old   = FactoryGirl.create(:participant, :lastname => "Two",   firstname: "A", birthdate: @camp_start-2.years, :grade => "pre-k").register
        three_year_old = FactoryGirl.create(:participant, :lastname => "Three", firstname: "B", birthdate: @camp_start-3.years, :grade => "pre-k").register
        four_year_old  = FactoryGirl.create(:participant, :lastname => "Four",  firstname: "C", birthdate: @camp_start-4.years, :grade => "pre-k").register
        five_year_old  = FactoryGirl.create(:participant, :lastname => "Five",  firstname: "D", birthdate: @camp_start-5.years, :grade => "pre-k").register
        six_year_old_going_into_kindergarten = FactoryGirl.create(:participant, :lastname => "Six", :firstname => "K",   birthdate: @camp_start-6.years, :grade => "kindergarten").register
        six_year_old_going_into_first_grade  = FactoryGirl.create(:participant, :lastname => "Six", :firstname => "1st", birthdate: @camp_start-6.years, :grade => "1st").register

        participants_by_grade = Participant.group_by_grade
        pre_k_group = participants_by_grade["2: pre_k"]

        expect(pre_k_group).not_to be_blank
        expect(pre_k_group).not_to include two_year_old
        expect(pre_k_group).to include three_year_old
        expect(pre_k_group).to include four_year_old
        expect(pre_k_group).to include five_year_old
        expect(pre_k_group).to include six_year_old_going_into_kindergarten
        expect(pre_k_group).not_to include six_year_old_going_into_first_grade
      end

      it "'younger elementary' group should include first and second grade" do
        kindergartener = FactoryGirl.create(:participant, :lastname => "Kay",    firstname: "A", birthdate: @camp_start-5.years, :grade => "Kindergarten").register
        first_grader   = FactoryGirl.create(:participant, :lastname => "First",  firstname: "B", birthdate: @camp_start-6.years, :grade => "1st").register
        second_grader  = FactoryGirl.create(:participant, :lastname => "Second", firstname: "C", birthdate: @camp_start-7.years, :grade => "2nd").register
        third_grader   = FactoryGirl.create(:participant, :lastname => "Third",  firstname: "D", birthdate: @camp_start-8.years, :grade => "3rd").register

        participants_by_grade = Participant.group_by_grade
        younger_elementary_group = participants_by_grade["3: younger_elementary"]

        expect(younger_elementary_group).not_to be_blank
        expect(younger_elementary_group).not_to include kindergartener
        expect(younger_elementary_group).to include first_grader
        expect(younger_elementary_group).to include second_grader
        expect(younger_elementary_group).not_to include third_grader
      end

      it "'older elementary' group should include third and fourth grade" do
        second_grader = FactoryGirl.create(:participant, :lastname => "Second", firstname: "A", birthdate: @camp_start-7.years,  :grade => "2nd").register
        third_grader  = FactoryGirl.create(:participant, :lastname => "Third",  firstname: "B", birthdate: @camp_start-8.years,  :grade => "3rd").register
        fourth_grader = FactoryGirl.create(:participant, :lastname => "Fourth", firstname: "C", birthdate: @camp_start-9.years,  :grade => "4th").register
        fifth_grader  = FactoryGirl.create(:participant, :lastname => "Fifth",  firstname: "D", birthdate: @camp_start-10.years, :grade => "5th").register

        participants_by_grade = Participant.group_by_grade
        older_elementary_group = participants_by_grade["4: older_elementary"]

        expect(older_elementary_group).not_to be_blank
        expect(older_elementary_group).not_to include second_grader
        expect(older_elementary_group).to include third_grader
        expect(older_elementary_group).to include fourth_grader
        expect(older_elementary_group).not_to include fifth_grader
      end
      
      it "'middle school' group should include fifth to eighth grade" do
        fourth_grader  = FactoryGirl.create(:participant, lastname: "Fourth",  firstname: "A", birthdate: @camp_start-9.years,  grade: "4th").register
        fifth_grader   = FactoryGirl.create(:participant, lastname: "Fifth",   firstname: "B", birthdate: @camp_start-10.years, grade: "5th").register
        sixth_grader   = FactoryGirl.create(:participant, lastname: "Sixth",   firstname: "C", birthdate: @camp_start-11.years, grade: "6th").register
        seventh_grader = FactoryGirl.create(:participant, lastname: "Seventh", firstname: "D", birthdate: @camp_start-12.years, grade: "7th").register
        eighth_grader  = FactoryGirl.create(:participant, lastname: "Eighth",  firstname: "E", birthdate: @camp_start-13.years, grade: "8th").register
        ninth_grader   = FactoryGirl.create(:participant, lastname: "Ninth",   firstname: "F", birthdate: @camp_start-14.years, grade: "9th").register

        participants_by_grade = Participant.group_by_grade
        middle_school_group = participants_by_grade["5: middle_school"]

        expect(middle_school_group).not_to be_blank
        expect(middle_school_group).not_to include fourth_grader
        expect(middle_school_group).to include fifth_grader
        expect(middle_school_group).to include sixth_grader
        expect(middle_school_group).to include seventh_grader
        expect(middle_school_group).to include eighth_grader
        expect(middle_school_group).not_to include ninth_grader
      end

      it "'high school' group should include ninth to twelth grade" do
        eighth_grader   = FactoryGirl.create(:participant, lastname: "Eighth",   firstname: "A", birthdate: @camp_start-13.years, grade: "8th").register
        ninth_grader    = FactoryGirl.create(:participant, lastname: "Ninth",    firstname: "B", birthdate: @camp_start-14.years, grade: "9th").register
        tenth_grader    = FactoryGirl.create(:participant, lastname: "Tenth",    firstname: "C", birthdate: @camp_start-15.years, grade: "10th").register
        eleventh_grader = FactoryGirl.create(:participant, lastname: "Eleventh", firstname: "D", birthdate: @camp_start-16.years, grade: "11th").register
        twelfth_grader  = FactoryGirl.create(:participant, lastname: "Twelfth",  firstname: "E", birthdate: @camp_start-17.years, grade: "12th").register
        graduate        = FactoryGirl.create(:participant, lastname: "Grad",     firstname: "F", birthdate: @camp_start-18.years, grade: nil).register

        participants_by_grade = Participant.group_by_grade
        high_school_group = participants_by_grade["6: high_school"]

        expect(high_school_group).not_to be_blank
        expect(high_school_group).not_to include eighth_grader
        expect(high_school_group).to include ninth_grader
        expect(high_school_group).to include tenth_grader
        expect(high_school_group).to include eleventh_grader
        expect(high_school_group).to include twelfth_grader
        expect(high_school_group).not_to include graduate
      end

      it "'high school' group should not include 17 if grade field not populated" do
        seventeen_year_old_still_in_high_school       = FactoryGirl.create(:participant, firstname: "A", birthdate: @camp_start-17.years, grade: "12th").register
        seventeen_year_old_graduated_from_high_school = FactoryGirl.create(:participant, firstname: "B", birthdate: @camp_start-17.years, grade: nil).register

        participants_by_grade = Participant.group_by_grade
        high_school_group = participants_by_grade["6: high_school"]

        expect(high_school_group).not_to be_blank
        expect(high_school_group).not_to include seventeen_year_old_graduated_from_high_school
        expect(high_school_group).to include seventeen_year_old_still_in_high_school
      end

      it "'other' group should include over 18 if grade field populated" do
        eighteen_year_old_with_grade    = FactoryGirl.create(:participant, firstname: "A", birthdate: @camp_start-18.years, grade: "senior").register
        eighteen_year_old_without_grade = FactoryGirl.create(:participant, firstname: "B", birthdate: @camp_start-18.years, grade: nil).register

        participants_by_grade = Participant.group_by_grade
        other_group = participants_by_grade["7: other"]

        expect(other_group).not_to be_blank
        expect(other_group).to include eighteen_year_old_with_grade
        expect(other_group).not_to include eighteen_year_old_without_grade
      end
    end

    context "#group_by_birth_month" do
      it "should stuff" do
        pending
        #binding.pry # how many participants do I have?
      end
    end
  end

  context "sorting" do
    before do
      @camp_start = Date.new(2010,7,21)
      @camp_end = @camp_start+5.days
      FactoryGirl.create(:year, year: @camp_start.year, starts_on: @camp_start, ends_on: @camp_end)

      # create 4 people who are the same age, 2 with same last name, so we can test secondary sorting by name
      # And make sure some in the same grade are different ages so we can test that sorting
      @adam   = FactoryGirl.create(:participant, firstname: "Adam",   lastname: "Apple",
                                   birthdate: @camp_start - 11.years, grade: "6th")
      @paul   = FactoryGirl.create(:participant, firstname: "Paul",   lastname: "Pear",
                                   birthdate: @camp_start - 10.years, grade: "6th")
      @patty  = FactoryGirl.create(:participant, firstname: "Patty",  lastname: "Pear",
                                   birthdate: @camp_start - 10.years, grade: "5th")
      @bill   = FactoryGirl.create(:participant, firstname: "Bill",   lastname: "Banana",
                                   birthdate: @camp_start - 9.years,  grade: "4th")
      @barry  = FactoryGirl.create(:participant, firstname: "Barry",  lastname: "Elder",
                                   birthdate: @camp_start - 10.years, grade: "4th")
      @cherry = FactoryGirl.create(:participant, firstname: "Cherry", lastname: "Cordial",
                                   birthdate: @camp_start - 10.years, grade: "5th")
    end

    it "should sort by 'list_name' by default" do
      unsorted = ["Apple, Adam", "Pear, Paul", "Pear, Patty", "Banana, Bill", "Elder, Barry", "Cordial, Cherry"]
      sorted =   ["Apple, Adam", "Banana, Bill", "Cordial, Cherry", "Elder, Barry", "Pear, Patty", "Pear, Paul"]
      expect(Participant.all.map{|p| p.list_name}).to eq unsorted
      expect(Participant.all.sort.map{|p| p.list_name}).to eq sorted
    end

    context "#sort_by_age" do
      it "should sort by age, then by name" do
        sorted_participants = Participant.sort_by_age([@cherry, @bill, @adam, @paul, @barry, @patty])
        expected_participants = [@bill, @cherry, @barry, @patty, @paul, @adam]
        expect(sorted_participants).to eq(expected_participants),
                                       "\n!!! Expected #{expected_participants.map{|p| p.full_name}}, \n!!! Got #{sorted_participants.map{|p| p.full_name}}"
      end
    end

    context "#sort_by_grade" do
      it "should sort by grade, then by age" do
        sorted_participants = Participant.sort_by_grade([@cherry, @bill, @adam, @paul, @barry, @patty])
        expected_participants = [@bill, @barry, @cherry, @patty, @paul, @adam]
        expect(sorted_participants).to eq(expected_participants),
                                       "\n!!! Expected #{expected_participants.map{|p| p.full_name}}, \n!!! Got #{sorted_participants.map{|p| p.full_name}}"
      end
    end

    context "#sort_by_name" do
      it "should sort by last name, first name" do
        sorted_participants = Participant.sort_by_name([@cherry, @bill, @adam, @paul, @barry, @patty])
        expected_participants = [@adam, @bill, @cherry, @barry, @patty, @paul]
        expect(sorted_participants).to eq(expected_participants),
                                       "\n!!! Expected #{expected_participants.map{|p| p.full_name}}, \n!!! Got #{sorted_participants.map{|p| p.full_name}}"
      end
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
