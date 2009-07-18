require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase

fixtures :participants

    def test_should_find_non_users
      nu = participants(:non_user)
      nu.save
      
      non_staff = Participant.find_non_staff_participants
      assert_equal(1, non_staff.size)
      assert_equal nu, non_staff[0]
    end
    
    def test_should_not_find_existing_users
      staff = create_user
      non_staff = Participant.find_non_staff_participants
      assert_equal(1, non_staff.size)
      assert_not_equal staff, non_staff[0]
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
