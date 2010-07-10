require File.dirname(__FILE__) + '/../test_helper'

class FamilyTest < ActiveSupport::TestCase

  def test_should_get_multiple_family_members
    f = Factory(:family)

    assert_equal 3, f.participants.size
  end

  def test_should_not_be_able_to_create_a_family_with_no_participants
    f = Factory.build(:family, :participants => [])
    f.save
    assert f.errors.on(:participants)    
  end

  #validates_presence_of

end
