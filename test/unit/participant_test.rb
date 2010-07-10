require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase

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
