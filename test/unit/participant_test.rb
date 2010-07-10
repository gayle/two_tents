require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase

    def setup
      @camp_start = Date.new(2010,7,21)
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

#    def test_should_not_find_existing_users
#      Factory(:user)
#      non_staff = Participant.find_non_staff_participants
#      assert_equal(9, non_staff.size)
#    end
#
#    def test_fullname_should_handle_firstname_being_nil
#      p = Factory(:participant, :firstname => nil)
#
#      verify_fullname_is_unharmed_by_nulls p
#    end
#
#    def test_fullname_should_handle_lastname_being_nil
#      p = Factory(:participant, :lastname => nil)
#
#      verify_fullname_is_unharmed_by_nulls p
#    end
#
#    def test_fullname_should_handle_both_names_being_nil
#      p = Factory(:participant, :firstname => nil, :lastname => nil)
#
#      verify_fullname_is_unharmed_by_nulls p
#    end
#
#    def test_participant_cannot_be_destroyed_if_it_belongs_to_a_user
#      u = Factory(:user)
#      u.destroy
#      assert_equal 19, Participant.all.size
#    end

  private
    def verify_fullname_is_unharmed_by_nulls(participant)
      assert_not_nil participant.fullname, "resulting fullname was nil"
      assert !participant.fullname.include?("nil"), "the string fullname shouldn't contain the word nil if the value is nil"
    end
end
