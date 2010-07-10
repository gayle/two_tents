require File.dirname(__FILE__) + '/../test_helper'

class FamilyTest < ActiveSupport::TestCase

  def test_should_get_multiple_family_members 
    fam = Family.new(:familyname => 'xyzzy')
    mary = Participant.create(:firstname => "Mary", :lastname => "Smith", :birthdate => '1/1/1990', :state => "OH")
    john = Participant.create(:firstname => "John", :lastname => "Smith", :birthdate => '1/1/1990', :state => "OH")
    fam.participants << mary
    fam.participants << john
    assert fam.save
    fam.reload

    assert_equal 2, fam.participants.size
  end
end
