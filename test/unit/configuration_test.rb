require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

fixtures :configurations

  # Replace this with your real tests.
  def we_can_find_the_current_configuration
    assert ! Confguration.current.nil?
  end

  def if_we_add_a_record_it_becomes_current
    nextyear = Configuration.current.year + 1
    Configuration.create(:year => nextyear)
    assert (Configuration.current.year == nextyear)
  end

end
