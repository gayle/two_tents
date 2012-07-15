require File.dirname(__FILE__) + '/../test_helper'

class ParticipantTest < ActiveSupport::TestCase
  def setup
    @camp_start = Date.new(2010,7,21)
    Rails.logger.fatal("\n\n\n\n\n\n\n\n\n\n CREATING NEW YEAR #{@camp_start}--")
    Year.create!(:year=>"#{@camp_start.year}",
                 :starts_on => "#{@camp_start.strftime("%m/%d/%Y")}",
                 :ends_on   => "#{(@camp_start+5.days).strftime("%m/%d/%Y")}")
    9.times { Factory(:user) }
    9.times { Factory(:participant) }
    Rails.logger.fatal("\n\n--")
  end

  def test_current
    current_year = Year.current
    past_year = Year.create!(:year => current_year.year-1,
                             :starts_on => current_year.starts_on - 1.year,
                             :ends_on => current_year.ends_on - 1.year)
    current_participant = Participant.create!(:firstname => "Baby", :lastname => "Smurf",
                                              :birthdate => Date.parse("2009-10-24"))
    past_participant = Participant.create!(:firstname => "Captain", :lastname => "Kangaroo",
                                           :birthdate => Date.parse("1924-01-16"))
    past_participant.years = [past_year] # remove current year that gets added by default. They have only past year.
    past_participant.save!
    repeat_participant = Participant.create!(:firstname => "Papa", :lastname => "Smurf",
                                             :birthdate => Date.parse("1941-01-16"))
    repeat_participant.years << past_year # append past year to current year that gets added by default.
    repeat_participant.save!

    current_participants = Participant.current
    assert current_participants.include?(repeat_participant), "#{repeat_participant.inspect} should have been included in\n#{current_participants.inspect}"
    assert current_participants.include?(current_participant), "#{current_participant.inspect} should have been included in\n#{current_participants.inspect}"
    assert_false current_participants.include?(past_participant), "#{past_participant.inspect} should NOT have been included in\n#{current_participants.inspect}"
  end

  def test_past
    current_year = Year.current
    past_year = Year.create!(:year => current_year.year-1,
                             :starts_on => current_year.starts_on - 1.year,
                             :ends_on => current_year.ends_on - 1.year)
    current_participant = Participant.create!(:firstname => "Baby", :lastname => "Smurf",
                                              :birthdate => Date.parse("2009-10-24"))
    past_participant = Participant.create!(:firstname => "Captain", :lastname => "Kangaroo",
                                           :birthdate => Date.parse("1924-01-16"))
    past_participant.years = [past_year] # remove current year that gets added by default. They have only past year.
    past_participant.save!
    repeat_participant = Participant.create!(:firstname => "Papa", :lastname => "Smurf",
                                             :birthdate => Date.parse("1941-01-16"))
    repeat_participant.years << past_year # append past year to current year that gets added by default.
    repeat_participant.save!

    past_participants = Participant.past
    assert_false past_participants.include?(repeat_participant), "#{repeat_participant.inspect} should NOT have been included in\n#{past_participants.inspect}"
    assert past_participants.include?(past_participant), "#{past_participant.inspect} should have been included in\n#{past_participants.inspect}"
    assert_false past_participants.include?(current_participant), "#{current_participant.inspect} should NOT have been included in\n#{past_participants.inspect}"
  end

  def test_should_be_able_to_decide_not_to_be_staff
    @user = Factory(:user)
    @participant = @user.participant
    assert_equal Participant.find_by_user_id(@user.id), @participant
    @user.quit_staff_and_remain_participant
    assert_equal [], User.all(:conditions => {:id => @user.id})
    assert_nil @participant.user_id
  end

  def test_there_18_users_created_by_fixtures
    assert_equal 18, Participant.all.size
  end

  def test_there_9_non_staff_users_created_by_fixtures
    assert_equal 9, Participant.find_non_staff_participants.size
  end

  def test_should_find_non_users
    Factory(:participant)

    non_staff = Participant.find_non_staff_participants
    assert_equal(10, non_staff.size)
  end

  def test_should_not_find_existing_users
    Factory(:user)
    non_staff = Participant.find_non_staff_participants
    assert_equal(9, non_staff.size)
  end

  def test_firstname_should_not_nil
    p = Factory.build(:participant, :firstname => nil)
    p.save

    assert p.errors.on(:firstname)
  end

  def test_lastname_should_not_nil
    p = Factory.build(:participant, :lastname => nil)
    p.save

    assert p.errors.on(:lastname)
  end

  def test_birthdate_should_not_be_nil
    p = Factory.build(:participant, :birthdate => nil)
    p.save

    assert p.errors.on(:birthdate)
  end

  def test_participant_cannot_be_destroyed_if_it_belongs_to_a_user
    u = Factory(:user)
    u.destroy
    assert_equal 19, Participant.all.size
  end

  def test_under_one_month
    p = Participant.new(:birthdate => @camp_start.advance(:days => -10))
    assert_equal [0,0,10], p.age_parts
    assert_equal 0, p.age
    assert_equal "10 days", p.display_age
  end

  def test_under_one_year
    p = Participant.new(:birthdate => @camp_start.advance(:months => -9, :days => -21))
    assert_equal [0,9,21], p.age_parts
    assert_equal 0, p.age
    assert_equal "9 months", p.display_age
  end

  def test_one_year_edge_case
    p = Participant.new(:birthdate => @camp_start.advance(:months => -11, :days => -29))
    assert_equal [0,11,29], p.age_parts
    assert_equal 0, p.age
    assert_equal "11 months", p.display_age
  end

  def test_over_one_year
    p = Participant.new(:birthdate => @camp_start.advance(:years => -1, :months => -10, :days => -10))
    assert_equal [1,10,10], p.age_parts
    assert_equal 1, p.age
    assert_equal "22 months", p.display_age
  end

  def test_over_ten_years
    p = Participant.new(:birthdate => @camp_start.advance(:years => -10, :months => -10, :days => -10))
    assert_equal [10,10,10], p.age_parts
    assert_equal 10, p.age
    assert_equal "10", p.display_age
  end

  def test_new_participant_automatically_registered_for_current_year
    yr = Year.current
    p = Participant.new(:firstname => "Marge", :lastname => "Simpson", :birthdate => Date.parse("04-06-1962"))
    assert p.years.include?(yr), "#{p.years.inspect} did not include '#{yr.inspect}'"
  end

  def test_existing_participant_not_automatically_registered_for_current_year_on_find_or_save
    this_yr = Year.current
    p = Participant.create!(:firstname => "Marge", :lastname => "Bouvier", :birthdate => Date.parse("04-06-1962"))

    next_yr = Year.create!(:year => this_yr.year+1, :starts_on => 10.days.from_now, :ends_on => 30.days.from_now)
    assert_equal 2, Year.all.size

    marge = Participant.find_by_id(p.id)
    assert_equal 1, marge.years.size
    assert marge.years.include?(this_yr)
    assert !marge.years.include?(next_yr)

    marge.lastname = "Simpson"
    marge.save!
    marge.reload
    assert_equal 1, marge.years.size
    assert marge.years.include?(this_yr)
    assert !marge.years.include?(next_yr)
  end

  def test_full_address_should_be_blank_if_all_necessary_fields_blank
    p = Participant.new
    p.address = ""
    p.city = ""
    p.state = ""
    p.zip = ""
    assert p.full_address.blank?
  end

  def test_full_address_should_display_correctly_when_necessary_fields_are_missing
    p = Participant.new
    assert p.full_address.blank?
    p.address = "123 Fake St."
    assert_equal "123 Fake St.", p.full_address
    p.city = "Columbus"
    assert_equal "123 Fake St., Columbus", p.full_address
    p.state = "OH"
    assert_equal "123 Fake St., Columbus, OH", p.full_address
    p.zip = "43215"
    assert_equal "123 Fake St., Columbus, OH 43215", p.full_address
  end

  def test_participant_input_trimmed
    p = Participant.new(:firstname => ' firstname ', :lastname => ' lastname ',
                        :address => ' address ', :city => ' city ', :zip => ' 12345 ',
                        :homechurch => ' homechurch ', :phone => ' 1231231234 ',
                        :mobile => ' 1231231234 ', :email => ' e@mail.com ',
                        :occupation => ' occupation ', :employer => ' employer ',
                        :school => ' school ', :grade => ' 11 ', :trivia => ' trivia ')
    p.save
    assert_equal 'firstname', p.firstname
    assert_equal 'lastname', p.lastname
    assert_equal 'city', p.city
    assert_equal '12345', p.zip
    assert_equal 'homechurch', p.homechurch
    assert_equal '1231231234', p.phone
    assert_equal '1231231234', p.mobile
    assert_equal 'e@mail.com', p.email
    assert_equal 'occupation', p.occupation
    assert_equal 'employer', p.employer
    assert_equal 'school', p.school
    assert_equal '11', p.grade
    assert_equal 'trivia', p.trivia
  end

  def test_birthday_during_camp
    y = Year.create!(:year => "#{Date.today.year}",
                     :starts_on => 3.days.from_now,
                     :ends_on => 7.days.from_now)
    p = Participant.new(:birthdate => 5.days.from_now - 1.year)
    assert p.birthday_during_camp?, "Participant with birthdate '#{p.birthdate}' does not occur during camp year #{Year.current}"
  end

  def test_birthday_not_during_camp
    p = Participant.new(:birthdate => @camp_start - 1.day)
    assert !p.birthday_during_camp?, "Participant with birthdate '#{p.birthdate}' does not occur during camp year #{Year.current}"
  end

  def test_age_hidden_for_adult
    p = Participant.new(:birthdate => Year.current.starts_on - 18.years)
    assert p.hide_age?
    p = Participant.new(:birthdate => 43.years.ago)
    assert p.hide_age?
  end

  def test_age_not_hidden_for_kids
    p = Participant.new(:birthdate => Year.current.starts_on - 17.years)
    assert !p.hide_age?
    p = Participant.new(:birthdate => 3.years.ago)
    assert !p.hide_age?
  end

  # I'm not sure this is a valid test.  If there's no grade, then how can we know what to do with them?
  # With the exception of babies, they may not have a grade.
  def test_group_by_grade_should_include_16_and_under_with_or_without_grade_field_populated
    start_of_camp = Year.current.starts_on
    baby_without_grade = Participant.new(:lastname => "Tester", :firstname => "Baby",
                                         :birthdate => start_of_camp-1.years)
    baby_without_grade.save!
    six_year_old_with_grade = Participant.new(:lastname => "Tester", :firstname => "Tommy",
                                              :birthdate => start_of_camp-6.years, :grade => "1st grade")
    six_year_old_with_grade.save!

    six_year_old_without_grade = Participant.new(:lastname => "Tester", :firstname => "Timmy",
                                                 :birthdate => start_of_camp-6.years)
    six_year_old_without_grade.save!
    sixteen_year_old_with_grade = Participant.new(:lastname => "Tester", :firstname => "Tom",
                                                   :birthdate => start_of_camp-16.years, :grade => "12th")
    sixteen_year_old_with_grade.save!
    sixteen_year_old_without_grade = Participant.new(:lastname => "Tester", :firstname => "Tim",
                                                      :birthdate => start_of_camp-16.years)
    sixteen_year_old_without_grade.save!

    assert Participant.current.count > 0
    assert Participant.registered.count > 0

    participants_by_grade = Participant.group_by_grade
    high_school_group = participants_by_grade["6: high_school"]
    assert_false high_school_group.blank?, "high school group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"
    younger_elementary_group = participants_by_grade["3: younger_elementary"]
    assert_false younger_elementary_group.blank?, "younger elementary group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"
    child_care_group = participants_by_grade["1: child_care"]
    assert_false child_care_group.blank?, "child care group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"

    assert (child_care_group.include? baby_without_grade),
               "#{child_care_group.inspect} \n should have included \n #{baby_without_grade.inspect}"
    assert (younger_elementary_group.include? six_year_old_with_grade),
               "#{younger_elementary_group.inspect} \n should have included \n #{six_year_old_with_grade.inspect}"
    assert (high_school_group.include? sixteen_year_old_with_grade),
               "#{high_school_group.inspect} \n should have included \n #{sixteen_year_old_with_grade.inspect}"

    # TODO What about this situation? Should we be accounting for age in kids that should have a grade?
    #assert (participants_by_grade["3: younger_elementary"].include? six_year_old_without_grade),
    #                                           "#{participants_by_grade["3: younger_elementary"].inspect} \n should have included \n #{six_year_old_without_grade.inspect}"
    #assert (participants_by_grade["4: high_school"].include? sixteen_year_old_without_grade),
    #                                           "#{participants_by_grade["4: high_school"].inspect} \n should have included \n #{sixteen_year_old_with_grade.inspect}"

  end

  def test_group_by_grade_should_not_include_17_if_grade_field_not_populated
    start_of_camp = Year.current.starts_on
    seventeen_year_old_still_in_high_school = Participant.new(:lastname => "Tester", :firstname => "Tom",
                                                    :birthdate => start_of_camp-17.years, :grade => "12th")
    seventeen_year_old_still_in_high_school.save!
    seventeen_year_old_graduated_from_high_school = Participant.new(:lastname => "Tester", :firstname => "Tim",
                                                       :birthdate => start_of_camp-17.years)
    seventeen_year_old_graduated_from_high_school.save!

    participants_by_grade = Participant.group_by_grade

    high_school_group = participants_by_grade["6: high_school"]
    assert_false high_school_group.blank?, "Group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"
    assert !(high_school_group.include? seventeen_year_old_graduated_from_high_school),
           "#{high_school_group.inspect} \n should NOT have included \n #{seventeen_year_old_graduated_from_high_school.inspect}"
    assert (high_school_group.include? seventeen_year_old_still_in_high_school),
           "#{high_school_group.inspect} \n should have included \n #{seventeen_year_old_still_in_high_school.inspect}"
  end

  def test_group_by_grade_should_include_over_18_if_grade_field_populated
    start_of_camp = Year.current.starts_on
    eighteen_year_old_with_grade = Participant.new(:lastname => "Tester", :firstname => "Thomas",
                                                   :birthdate => start_of_camp-18.years, :grade => "senior")
    eighteen_year_old_with_grade.save!
    eighteen_year_old_without_grade = Participant.new(:lastname => "Tester", :firstname => "Timothy",
                                                      :birthdate => start_of_camp-18.years)
    eighteen_year_old_without_grade.save!

    participants_by_grade = Participant.group_by_grade
    other_group = participants_by_grade["7: other"]
    assert_false other_group.blank?, "Group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"

    assert (other_group.include? eighteen_year_old_with_grade),
           "#{other_group.inspect} \n should have included \n #{eighteen_year_old_with_grade.inspect}"
    assert !(other_group.include? eighteen_year_old_without_grade),
           "#{other_group.inspect} \n should have included \n #{eighteen_year_old_without_grade.inspect}"
  end

  def test_group_by_grade_should_include_age_0_to_2_in_child_care_group
    start_of_camp = Year.current.starts_on
    zero_year_old = Participant.new(:lastname => "Zero", :firstname => "A", :birthdate => start_of_camp-18.days)
    zero_year_old.save!
    one_year_old = Participant.new(:lastname => "One", :firstname => "B", :birthdate => start_of_camp-1.year)
    one_year_old.save!
    two_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => start_of_camp-2.years)
    two_year_old.save!
    three_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => start_of_camp-3.years)
    three_year_old.save!

    participants_by_grade = Participant.group_by_grade
    child_care_group = participants_by_grade["1: child_care"]
    assert_false child_care_group.blank?, "Group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"

    assert (child_care_group.include? zero_year_old),
           "#{child_care_group.inspect} \n should have included \n #{zero_year_old.inspect}"
    assert (child_care_group.include? one_year_old),
           "#{child_care_group.inspect} \n should have included \n #{one_year_old.inspect}"
    assert (child_care_group.include? two_year_old),
           "#{child_care_group.inspect} \n should have included \n #{two_year_old.inspect}"
    assert !(child_care_group.include? three_year_old),
           "#{child_care_group.inspect} \n should NOT have included \n #{three_year_old.inspect}"
  end

  def test_group_by_grade_should_include_age_3_to_5_going_into_kindergarten_in_pre_k_group
    start_of_camp = Year.current.starts_on

    two_year_old = Participant.new(:lastname => "Two", :firstname => "A", :birthdate => start_of_camp-2.years, :grade => "pre-k")
    two_year_old.save!
    three_year_old = Participant.new(:lastname => "Three", :firstname => "B", :birthdate => start_of_camp-3.years, :grade => "pre-k")
    three_year_old.save!
    four_year_old = Participant.new(:lastname => "Four", :firstname => "C", :birthdate => start_of_camp-4.years, :grade => "pre-k")
    four_year_old.save!
    five_year_old = Participant.new(:lastname => "Five", :firstname => "D", :birthdate => start_of_camp-5.years, :grade => "pre-k")
    five_year_old.save!
    six_year_old_going_into_kindergarten = Participant.new(:lastname => "Six", :firstname => "K", :birthdate => start_of_camp-6.years, :grade => "kindergarten")
    six_year_old_going_into_kindergarten.save!
    six_year_old_going_into_first_grade = Participant.new(:lastname => "Six", :firstname => "1st", :birthdate => start_of_camp-6.years, :grade => "1st")
    six_year_old_going_into_first_grade.save!

    participants_by_grade = Participant.group_by_grade
    pre_k_group = participants_by_grade["2: pre_k"]
    assert_false pre_k_group.blank?, "Group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"

    assert !(pre_k_group.include? two_year_old),
           "#{pre_k_group.inspect} \n should NOT have included \n #{two_year_old.inspect}"
    assert (pre_k_group.include? three_year_old),
           "#{pre_k_group.inspect} \n should have included \n #{three_year_old.inspect}"
    assert (pre_k_group.include? four_year_old),
           "#{pre_k_group.inspect} \n should have included \n #{four_year_old.inspect}"
    assert (pre_k_group.include? five_year_old),
           "#{pre_k_group.inspect} \n should have included \n #{five_year_old.inspect}"
    assert (pre_k_group.include? six_year_old_going_into_kindergarten),
           "#{pre_k_group.inspect} \n should have included \n #{six_year_old_going_into_kindergarten.inspect}"
    assert !(pre_k_group.include? six_year_old_going_into_first_grade),
           "#{pre_k_group.inspect} \n should NOT have included \n #{six_year_old_going_into_first_grade.inspect}"
  end

  def test_group_by_grade_should_include_first_and_second_grade_in_younger_elementary_group
    start_of_camp = Year.current.starts_on
    kindergartener = Participant.create!(:lastname => "Kay", :firstname => "A", :birthdate => start_of_camp-5.years, :grade => "Kindergarten")
    first_grader = Participant.create!(:lastname => "First", :firstname => "B", :birthdate => start_of_camp-6.years, :grade => "1st")
    second_grader = Participant.create!(:lastname => "Second", :firstname => "C", :birthdate => start_of_camp-7.years, :grade => "2nd")
    third_grader = Participant.create!(:lastname => "Third", :firstname => "D", :birthdate => start_of_camp-8.years, :grade => "3rd")

    participants_by_grade = Participant.group_by_grade
    younger_elementary_group = participants_by_grade["3: younger_elementary"]
    assert_false younger_elementary_group.blank?, "Group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"

    assert !(younger_elementary_group.include? kindergartener),
           "#{younger_elementary_group.inspect} \n should NOT have included \n #{kindergartener.inspect}"
    assert (younger_elementary_group.include? first_grader),
           "#{younger_elementary_group.inspect} \n should have included \n #{first_grader.inspect}"
    assert (younger_elementary_group.include? second_grader),
           "#{younger_elementary_group.inspect} \n should have included \n #{second_grader.inspect}"
    assert !(younger_elementary_group.include? third_grader),
           "#{younger_elementary_group.inspect} \n should NOT have included \n #{third_grader.inspect}"
  end

  def test_group_by_grade_should_include_third_and_fourth_grade_in_older_elemetary_group
    start_of_camp = Year.current.starts_on
    second_grader = Participant.create!(:lastname => "Second", :firstname => "A", :birthdate => start_of_camp-7.years, :grade => "2nd")
    third_grader = Participant.create!(:lastname => "Third", :firstname => "B", :birthdate => start_of_camp-8.years, :grade => "3rd")
    fourth_grader = Participant.create!(:lastname => "Fourth", :firstname => "C", :birthdate => start_of_camp-9.years, :grade => "4th")
    fifth_grader = Participant.create!(:lastname => "Fifth", :firstname => "D", :birthdate => start_of_camp-10.years, :grade => "5th")

    participants_by_grade = Participant.group_by_grade
    older_elementary_group = participants_by_grade["4: older_elementary"]
    assert_false older_elementary_group.blank?, "Group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"

    assert !(older_elementary_group.include? second_grader),
           "#{older_elementary_group.inspect} \n should NOT have included \n #{second_grader.inspect}"
    assert (older_elementary_group.include? third_grader),
           "#{older_elementary_group.inspect} \n should have included \n #{third_grader.inspect}"
    assert (older_elementary_group.include? fourth_grader),
           "#{older_elementary_group.inspect} \n should have included \n #{fourth_grader.inspect}"
    assert !(older_elementary_group.include? fifth_grader),
           "#{older_elementary_group.inspect} \n should NOT have included \n #{fifth_grader.inspect}"
  end

  def test_group_by_grade_should_include_fifth_to_eighth_grade_in_middle_school_group
    start_of_camp = Year.current.starts_on

    fourth_grader = Participant.create!(:lastname => "Fourth", :firstname => "D", :birthdate => start_of_camp-9.years, :grade => "4th")
    fifth_grader = Participant.create!(:lastname => "Fifth", :firstname => "D", :birthdate => start_of_camp-10.years, :grade => "5th")
    sixth_grader = Participant.create!(:lastname => "Sixth", :firstname => "D", :birthdate => start_of_camp-11.years, :grade => "6th")
    seventh_grader = Participant.create!(:lastname => "Seventh", :firstname => "D", :birthdate => start_of_camp-12.years, :grade => "7th")
    eighth_grader = Participant.create!(:lastname => "Eighth", :firstname => "D", :birthdate => start_of_camp-13.years, :grade => "8th")
    ninth_grader = Participant.create!(:lastname => "Ninth", :firstname => "D", :birthdate => start_of_camp-14.years, :grade => "9th")

    participants_by_grade = Participant.group_by_grade
    middle_school_group = participants_by_grade["5: middle_school"]
    assert_false middle_school_group.blank?, "Group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"

    assert !(middle_school_group.include? fourth_grader),
           "#{middle_school_group.inspect} \n should NOT have included \n #{fourth_grader.inspect}"
    assert (middle_school_group.include? fifth_grader),
           "#{middle_school_group.inspect} \n should have included \n #{fifth_grader.inspect}"
    assert (middle_school_group.include? sixth_grader),
           "#{middle_school_group.inspect} \n should have included \n #{sixth_grader.inspect}"
    assert (middle_school_group.include? seventh_grader),
           "#{middle_school_group.inspect} \n should have included \n #{seventh_grader.inspect}"
    assert (middle_school_group.include? eighth_grader),
           "#{middle_school_group.inspect} \n should have included \n #{eighth_grader.inspect}"
    assert !(middle_school_group.include? ninth_grader),
           "#{middle_school_group.inspect} \n should NOT have included \n #{ninth_grader.inspect}"
  end

  def test_group_by_grade_should_include_ninth_to_twelth_grade_in_high_school_group
    start_of_camp = Year.current.starts_on

    eighth_grader = Participant.create!(:lastname => "Eighth", :firstname => "D", :birthdate => start_of_camp-13.years, :grade => "8th")
    ninth_grader = Participant.create!(:lastname => "Ninth", :firstname => "D", :birthdate => start_of_camp-14.years, :grade => "9th")
    tenth_grader = Participant.create!(:lastname => "Tenth", :firstname => "D", :birthdate => start_of_camp-15.years, :grade => "10th")
    eleventh_grader = Participant.create!(:lastname => "Eleventh", :firstname => "D", :birthdate => start_of_camp-16.years, :grade => "11th")
    twelfth_grader = Participant.create!(:lastname => "Twelfth", :firstname => "D", :birthdate => start_of_camp-17.years, :grade => "12th")
    graduate = Participant.create!(:lastname => "Grad", :firstname => "D", :birthdate => start_of_camp-18.years)

    participants_by_grade = Participant.group_by_grade
    high_school_group = participants_by_grade["6: high_school"]
    assert_false high_school_group.blank?, "Group should not be blank.\nparticipants_by_grade is:\n#{participants_by_grade.inspect}"

    assert !(high_school_group.include? eighth_grader),
           "#{high_school_group.inspect} \n should NOT have included \n #{eighth_grader.inspect}"
    assert (high_school_group.include? ninth_grader),
           "#{high_school_group.inspect} \n should have included \n #{ninth_grader.inspect}"
    assert (high_school_group.include? tenth_grader),
           "#{high_school_group.inspect} \n should have included \n #{tenth_grader.inspect}"
    assert (high_school_group.include? eleventh_grader),
           "#{high_school_group.inspect} \n should have included \n #{eleventh_grader.inspect}"
    assert (high_school_group.include? twelfth_grader),
           "#{high_school_group.inspect} \n should have included \n #{twelfth_grader.inspect}"
    assert !(high_school_group.include? graduate),
           "#{high_school_group.inspect} \n should NOT have included \n #{graduate.inspect}"
  end

  def test_add_current_year
    p = Participant.new
    p.add_current_year
    assert_equal 1, p.years.size

    #Can't add doubles
    p.add_current_year
    assert_equal 1, p.years.size
  end

  def remove_current_year
    p = Participant.new
    #Shouldn't crash if it doesn't have this year already
    p.remove_current_year
    p.add_current_year
    p.remove_current_year
    assert_equal 0, p.years.size
  end
end
