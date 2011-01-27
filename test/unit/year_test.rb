require 'test_helper'

class YearTest < ActiveSupport::TestCase

fixtures :years

  # Replace this with your real tests.
  def we_can_find_the_current_year
    assert ! Year.current.nil?
  end

  def if_we_add_a_record_it_becomes_current
    nextyear = Year.current.year + 1
    Year.create(:year => nextyear)
    assert (Year.current.year == nextyear)
  end

end
