require File.dirname(__FILE__) + '/../test_helper'

class ParticipantTest < ActiveSupport::TestCase
  def setup
    @camp_start = Date.new(2010,7,21)
    Year.create!(:year=>"#{@camp_start.year}",
                 :starts_on => "#{@camp_start.strftime("%m/%d/%Y")}",
                 :ends_on   => "#{(@camp_start+5.days).strftime("%m/%d/%Y")}")
    9.times { Factory(:user) }
    9.times { Factory(:participant) }
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

#  # TODO fix this, it passes individually, but not when running "rake"
#  def test_group_by_grade_should_include_18_and_under_with_or_without_grade_field_populated
#    start_of_camp = Year.current.starts_on
#    six_year_old_with_grade = Participant.new(:lastname => "Tester", :firstname => "Tommy",
#                                              :birthdate => start_of_camp-6.years, :grade => "1st grade")
#    six_year_old_with_grade.save!
#    six_year_old_without_grade = Participant.new(:lastname => "Tester", :firstname => "Timmy",
#                                                 :birthdate => start_of_camp-6.years)
#    six_year_old_without_grade.save!
#    eighteen_year_old_with_grade = Participant.new(:lastname => "Tester", :firstname => "Tom",
#                                                   :birthdate => start_of_camp-18.years, :grade => "12th")
#    eighteen_year_old_with_grade.save!
#    eighteen_year_old_without_grade = Participant.new(:lastname => "Tester", :firstname => "Tim",
#                                                      :birthdate => start_of_camp-18.years)
#    eighteen_year_old_without_grade.save!
#
#    participants_by_grade = Participant.group_by_grade
#
#    assert (participants_by_grade["elementary"].include? six_year_old_with_grade),
#                                               "#{participants_by_grade["elementary"].inspect} \n should have included \n #{six_year_old_with_grade.inspect}"
#    assert (participants_by_grade["elementary"].include? six_year_old_without_grade),
#                                               "#{participants_by_grade["elementary"].inspect} \n should have included \n #{six_year_old_without_grade.inspect}"
#    assert (participants_by_grade["high_school"].include? eighteen_year_old_with_grade)
#    assert (participants_by_grade["high_school"].include? eighteen_year_old_without_grade)
#  end

#  # TODO fix this, it passes individually, but not when running "rake"
#  def test_group_by_grade_should_include_over_18_if_grade_field_populated
#    puts "\n\n-----------------------------"
#    start_of_camp = Year.current.starts_on
#    nineteen_year_old_with_grade = Participant.new(:lastname => "Tester", :firstname => "Thomas",
#                                                   :birthdate => start_of_camp-19.years, :grade => "sophomore in college")
#    nineteen_year_old_with_grade.save!
#    nineteen_year_old_without_grade = Participant.new(:lastname => "Tester", :firstname => "Timothy",
#                                                      :birthdate => start_of_camp-19.years)
#    nineteen_year_old_without_grade.save!
#
#    participants_by_grade = Participant.group_by_grade
#
#    assert (participants_by_grade["other"].include? nineteen_year_old_with_grade),
#                                                   "#{participants_by_grade["other"].inspect} \n should have included \n #{nineteen_year_old_with_grade.inspect}"
#    assert !(participants_by_grade["other"].include? nineteen_year_old_without_grade),
#                                                   "#{participants_by_grade["other"].inspect} \n should have included \n #{nineteen_year_old_without_grade.inspect}"
#    puts "-----------------------------\n\n"
#  end

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
