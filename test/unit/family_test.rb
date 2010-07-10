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

# Not made this pass yet. Soon! - Greg
#  def test_should_not_be_able_save_duplicate_families
#    original = Factory(:family, :familyname => "Candyman")
#    duplicate = Factory.build(:family, :familyname => "Candyman")
#    duplicate.save
#
#    assert_not_equal original.object_id, duplicate.object_id,
#      "Making sure factory_girl isn't giving us the same object twice"
#
#    assert duplicate.errors.on(:family)
#  end

end
