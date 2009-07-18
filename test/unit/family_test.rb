require File.dirname(__FILE__) + '/../test_helper'

class FamilyTest < ActiveSupport::TestCase

  def test_should_get_multiple_family_members 
    fam = Family.new
    mary = Participant.new(:firstname => "Mary", :lastname => "Smith", :family => fam)
    mary.save
    john = Participant.new(:firstname => "John", :lastname => "Smith", :family => fam)
    john.save
    fam.save
    fam.reload

    assert_equal 2, Family.find(:first).participants.size
  end
end
