require 'rubygems'
require 'watir' #require 'watir-webdriver'
require 'test/unit'

class WatirSpikeTest < Test::Unit::TestCase

  def setup
    @browser = Watir::Browser.new
  end

  def test_one
    @browser.goto 'http://localhost:3000'

  end
end