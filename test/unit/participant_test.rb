require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase

fixtures :participants

    def test_should_find_non_users
      nu = participants(:joannearnold)
      nu.save

      non_staff = Participant.find_non_staff_participants
      assert_equal(9, non_staff.size)
      assert_equal nu, non_staff[0]
    end
    
    def test_should_not_find_existing_users
      staff = create_user
      non_staff = Participant.find_non_staff_participants
      assert_equal(9, non_staff.size)
      assert_not_equal staff, non_staff[0]
    end

    def test_fullname_should_handle_nil_values
      p = participants(:quentin)

      p.firstname=nil
      assert p.fullname, "resulting fullname was nil"
      assert_equal false, p.fullname.include?("nil"), "the string fullname shouldn't contain the word nil if the value is nil"

      p.lastname = nil
      assert p.fullname, "resulting fullname was nil"
      assert_equal false, p.fullname.include?("nil"), "the string fullname shouldn't contain the word nil if the value is nil"
    end
    
    def test_participant_cannot_be_destroyed_if_it_belongs_to_a_user
      p = create_user.participant
      
      p.destroy
      assert_equal p, participants(:quentin)
    end

  protected
    def create_user
      record = User.new({ :login => 'quire', :email => 'quire@example.com',
                          :password => 'quire69', :password_confirmation => 'quire69' })
      record.participant = participants(:quentin)
      record.save
      record
    end
end
