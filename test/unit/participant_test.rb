require File.dirname(__FILE__) + '/../test_helper'

class ParticipantTest < ActiveSupport::TestCase
  def setup
    @camp_start = Date.new(2010,7,21)
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
  end
  def test_full_address_should_display_correctly_when_necessary_fields_are_missing
    p = Participant.new
    assert p.full_address.blank?
    p.address = "123 Fake St."
    assert_equal p.full_address, "123 Fake St."
    p.city = "Columbus"
    assert_equal p.full_address, "123 Fake St., Columbus"
    p.state = "OH"
    assert_equal p.full_address, "123 Fake St., Columbus, OH"
    p.zip = "43215"
    assert_equal p.full_address, "123 Fake St., Columbus, OH 43215"
  end
end
