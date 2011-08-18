require File.dirname(__FILE__) + '/../test_helper'

class FamilyTest < ActiveSupport::TestCase

  def main_contact(family)
    family.participants.reject{ |p| !p.main_contact }[0]
  end

  def test_should_get_multiple_family_members
    f = Factory(:family)

    assert_equal 3, f.participants.size
  end

  def test_should_not_be_able_to_create_a_family_with_no_participants
    f = Factory.build(:family, :participants => [])
    f.save
    assert f.errors.on(:participants)
  end

  def test_registered_for_current_year
    year1 = Factory(:year)
    fam1 = Factory(:family)
    fam2 = Factory(:family)
    assert_equal Family.all.size,  Family.registered.size

    # Make sure data is set up the way we expect it to be
    assert fam1.participants.size > 1
    assert fam2.participants.size > 1
    assert fam1.participants[0].years.size > 0
    assert fam2.participants[0].years.size > 0
    assert_equal year1, fam1.participants[0].years[0]
    assert_equal year1, fam2.participants[0].years[0]

    # Register only family 2 for a second year
    year2 = Factory(:year)
    fam2.participants.each do |p|
      p.years << year2
      p.save!
    end
    assert_equal Family.all.size - 1,  Family.registered.size,
                 "The number of families registered for #{year2.year} should be less than the total number of families in the system."
  end

  def test_registered_for_a_year_other_than_current
    year1 = Factory(:year)
    fam1 = Factory(:family)
    fam2 = Factory(:family)

    registered_families = Family.registered
    assert registered_families.include?(fam1)
    assert registered_families.include?(fam2)

    year2 = Factory(:year)
    registered_families = Family.registered
    assert !registered_families.include?(fam1)
    assert !registered_families.include?(fam2)

    fam1.participants[0].add_current_year()
    registered_families = Family.registered
    assert registered_families.include?(fam1)
    assert !registered_families.include?(fam2)

    registered_families = Family.registered(year1)
    assert registered_families.include?(fam1)
    assert registered_families.include?(fam2)
  end

end
