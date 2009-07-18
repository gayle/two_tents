require File.dirname(__FILE__) + '/../test_helper'

class FamilyTest < ActiveSupport::TestCase

  def test_should_get_multiple_family_members 
    fam = Family.new(:familyname => 'xyzzy')
    mary = Participant.create(:firstname => "Mary", :lastname => "Smith")
    john = Participant.create(:firstname => "John", :lastname => "Smith")
    fam.participants << mary
    fam.participants << john
    fam.save
    fam.reload

    assert_equal 2, fam.participants.size
  end
end
