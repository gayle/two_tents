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
end
